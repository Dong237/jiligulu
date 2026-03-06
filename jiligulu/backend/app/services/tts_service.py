"""TTS语音合成 — 抽象接口 + 实现"""
from __future__ import annotations
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import AsyncIterator
import httpx
import logging

logger = logging.getLogger(__name__)


@dataclass
class AudioChunk:
    """TTS合成的音频片段"""
    data: bytes
    sample_rate: int = 24000
    is_final: bool = False


class TTSProvider(ABC):
    """TTS抽象接口"""

    @abstractmethod
    async def synthesize_stream(
        self, text_stream: AsyncIterator[str], voice: str = "zh_female_warm"
    ) -> AsyncIterator[AudioChunk]:
        """流式合成：文本流 → 音频流"""
        ...

    @abstractmethod
    async def synthesize(
        self, text: str, voice: str = "zh_female_warm"
    ) -> bytes:
        """一次性合成完整文本 → 音频数据"""
        ...


class DoubaoTTS(TTSProvider):
    """豆包TTS实现"""

    def __init__(self, api_key: str, voice: str = "zh_female_warm"):
        self._api_key = api_key
        self._default_voice = voice
        self._client = httpx.AsyncClient(timeout=15.0)

    async def synthesize_stream(
        self, text_stream: AsyncIterator[str], voice: str | None = None
    ) -> AsyncIterator[AudioChunk]:
        voice = voice or self._default_voice

        # MVP: 收集文本后一次性合成
        text_buffer = []
        async for text_chunk in text_stream:
            text_buffer.append(text_chunk)

        full_text = "".join(text_buffer)
        if not full_text.strip():
            return

        audio_data = await self.synthesize(full_text, voice)
        yield AudioChunk(data=audio_data, is_final=True)

    async def synthesize(
        self, text: str, voice: str | None = None
    ) -> bytes:
        if not self._api_key:
            logger.warning("豆包TTS key未配置，返回空音频")
            return self._mock_audio()

        # TODO: 接入豆包TTS真实API
        logger.info(f"TTS合成 {len(text)} 字符")
        return self._mock_audio()

    @staticmethod
    def _mock_audio() -> bytes:
        """返回一段静音PCM数据作为placeholder"""
        # 0.5秒静音 @ 24kHz 16bit mono
        return b'\x00\x00' * 12000

    async def close(self):
        await self._client.aclose()


class MockTTS(TTSProvider):
    """Mock TTS — 开发调试用"""

    async def synthesize_stream(
        self, text_stream: AsyncIterator[str], voice: str = "zh_female_warm"
    ) -> AsyncIterator[AudioChunk]:
        async for _ in text_stream:
            pass
        yield AudioChunk(data=self._mock_audio(), is_final=True)

    async def synthesize(
        self, text: str, voice: str = "zh_female_warm"
    ) -> bytes:
        return self._mock_audio()

    @staticmethod
    def _mock_audio() -> bytes:
        return b'\x00\x00' * 12000
