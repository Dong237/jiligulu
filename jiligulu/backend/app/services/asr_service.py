"""ASR语音识别 — 抽象接口 + 实现"""
from __future__ import annotations
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import AsyncIterator
import httpx
import json
import logging

logger = logging.getLogger(__name__)


@dataclass
class TranscriptChunk:
    """ASR转写结果片段"""
    text: str
    is_final: bool
    confidence: float = 1.0
    language: str = "zh"  # zh or en


class ASRProvider(ABC):
    """ASR抽象接口 — 所有ASR实现必须继承此类"""

    @abstractmethod
    async def transcribe_stream(
        self, audio_chunks: AsyncIterator[bytes], sample_rate: int = 16000
    ) -> AsyncIterator[TranscriptChunk]:
        """流式转写音频 → 文本片段"""
        ...

    @abstractmethod
    async def transcribe_bytes(
        self, audio_data: bytes, sample_rate: int = 16000
    ) -> str:
        """一次性转写完整音频 → 文本（简单模式）"""
        ...


class AliyunASR(ASRProvider):
    """阿里云语音识别实现

    MVP阶段用非流式模式先跑通，后续升级为流式
    """

    def __init__(self, api_key: str, api_secret: str):
        self._api_key = api_key
        self._api_secret = api_secret
        self._client = httpx.AsyncClient(timeout=10.0)

    async def transcribe_stream(
        self, audio_chunks: AsyncIterator[bytes], sample_rate: int = 16000
    ) -> AsyncIterator[TranscriptChunk]:
        # MVP: 收集所有chunk后一次性转写
        audio_buffer = bytearray()
        async for chunk in audio_chunks:
            audio_buffer.extend(chunk)

        if not audio_buffer:
            return

        text = await self.transcribe_bytes(bytes(audio_buffer), sample_rate)
        if text:
            yield TranscriptChunk(text=text, is_final=True)

    async def transcribe_bytes(
        self, audio_data: bytes, sample_rate: int = 16000
    ) -> str:
        if not self._api_key:
            logger.warning("阿里云ASR key未配置，用mock模式")
            return "[mock ASR] 用户说了一些话"

        # TODO: 接入阿里云真实API
        # 现在返回mock结果，方便端到端联调
        logger.info(f"ASR收到 {len(audio_data)} 字节音频")
        return "[mock ASR] 用户说了一些话"

    async def close(self):
        await self._client.aclose()


class MockASR(ASRProvider):
    """Mock ASR — 开发调试用"""

    async def transcribe_stream(
        self, audio_chunks: AsyncIterator[bytes], sample_rate: int = 16000
    ) -> AsyncIterator[TranscriptChunk]:
        # 消费掉所有输入
        async for _ in audio_chunks:
            pass
        yield TranscriptChunk(text="Hello, 你好", is_final=True)

    async def transcribe_bytes(
        self, audio_data: bytes, sample_rate: int = 16000
    ) -> str:
        return "Hello, 你好"
