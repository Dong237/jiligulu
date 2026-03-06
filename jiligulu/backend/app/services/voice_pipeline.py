"""语音管线编排器 — App的心脏

串联 ASR → LLM → TTS 的流式级联处理。
用户说话 → ASR转写 → LLM生成回复 → TTS合成语音 → 返回给客户端
"""
from __future__ import annotations
from dataclasses import dataclass, field
from typing import AsyncIterator
import asyncio
import logging
import uuid

from .asr_service import ASRProvider, TranscriptChunk, MockASR
from .llm_service import LLMProvider, TextChunk, ChatMessage as LLMMessage, MockLLM
from .tts_service import TTSProvider, AudioChunk, MockTTS

logger = logging.getLogger(__name__)


@dataclass
class PipelineConfig:
    """管线配置"""
    temperature: float = 0.7
    max_tokens: int = 500
    tts_voice: str = "zh_female_warm"
    sample_rate: int = 16000


@dataclass
class PipelineResult:
    """管线处理结果"""
    user_text: str = ""
    assistant_text: str = ""
    audio_chunks: list[bytes] = field(default_factory=list)
    phrases_taught: list[dict] = field(default_factory=list)


@dataclass
class PipelineEvent:
    """管线事件 — 通过WebSocket推给客户端"""
    type: str  # transcript | response_text | response_audio | session_summary | error
    data: dict = field(default_factory=dict)


class VoicePipeline:
    """语音管线编排器"""

    def __init__(
        self,
        asr: ASRProvider | None = None,
        llm: LLMProvider | None = None,
        tts: TTSProvider | None = None,
    ):
        self.asr = asr or MockASR()
        self.llm = llm or MockLLM()
        self.tts = tts or MockTTS()

    async def process_audio(
        self,
        audio_data: bytes,
        conversation_history: list[LLMMessage],
        system_prompt: str,
        config: PipelineConfig | None = None,
    ) -> AsyncIterator[PipelineEvent]:
        """处理一轮语音交互

        audio_data: 用户录制的PCM音频
        conversation_history: 对话历史
        system_prompt: 系统提示词

        yields PipelineEvent 事件流
        """
        config = config or PipelineConfig()

        # Step 1: ASR — 语音转文字
        logger.info("ASR开始转写...")
        user_text = await self.asr.transcribe_bytes(audio_data, config.sample_rate)

        if not user_text or not user_text.strip():
            yield PipelineEvent(
                type="error",
                data={"message": "叽叽没听清，再说一遍？"}
            )
            return

        # 推送转写结果给客户端
        yield PipelineEvent(
            type="transcript",
            data={"text": user_text, "is_final": True}
        )

        # Step 2: LLM — 生成回复
        logger.info(f"LLM生成回复，用户说: {user_text[:50]}...")
        messages = [LLMMessage(role="system", content=system_prompt)]
        messages.extend(conversation_history)
        messages.append(LLMMessage(role="user", content=user_text))

        assistant_text_parts = []
        async for chunk in self.llm.generate_stream(
            messages, temperature=config.temperature, max_tokens=config.max_tokens
        ):
            if chunk.text:
                assistant_text_parts.append(chunk.text)
                yield PipelineEvent(
                    type="response_text",
                    data={"text": chunk.text, "is_final": False}
                )

        full_assistant_text = "".join(assistant_text_parts)
        yield PipelineEvent(
            type="response_text",
            data={"text": "", "is_final": True, "full_text": full_assistant_text}
        )

        # Step 3: TTS — 文字转语音
        logger.info(f"TTS合成语音，文本长度: {len(full_assistant_text)}")
        audio_data = await self.tts.synthesize(full_assistant_text, config.tts_voice)

        if audio_data:
            import base64
            yield PipelineEvent(
                type="response_audio",
                data={
                    "audio": base64.b64encode(audio_data).decode(),
                    "sample_rate": 24000,
                    "is_final": True,
                }
            )

    async def close(self):
        """关闭所有provider连接"""
        for provider in [self.asr, self.llm, self.tts]:
            if hasattr(provider, 'close'):
                await provider.close()
