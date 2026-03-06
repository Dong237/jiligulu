"""LLM大语言模型 — 抽象接口 + 实现"""
from __future__ import annotations
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import AsyncIterator
import httpx
import json
import logging

logger = logging.getLogger(__name__)


@dataclass
class TextChunk:
    """LLM生成的文本片段"""
    text: str
    is_final: bool = False


@dataclass
class ChatMessage:
    """对话消息"""
    role: str  # system / user / assistant
    content: str


class LLMProvider(ABC):
    """LLM抽象接口"""

    @abstractmethod
    async def generate_stream(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> AsyncIterator[TextChunk]:
        """流式生成文本"""
        ...

    @abstractmethod
    async def generate(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> str:
        """一次性生成完整文本"""
        ...


class DoubaoLLM(LLMProvider):
    """豆包API实现 — 兼容OpenAI API格式"""

    def __init__(self, api_key: str, model: str = "doubao-pro-32k"):
        self._api_key = api_key
        self._model = model
        self._base_url = "https://ark.cn-beijing.volces.com/api/v3"
        self._client = httpx.AsyncClient(timeout=30.0)

    async def generate_stream(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> AsyncIterator[TextChunk]:
        if not self._api_key:
            logger.warning("豆包API key未配置，用mock模式")
            for chunk in self._mock_response():
                yield chunk
            return

        payload = {
            "model": self._model,
            "messages": [{"role": m.role, "content": m.content} for m in messages],
            "temperature": temperature,
            "max_tokens": max_tokens,
            "stream": True,
        }

        try:
            async with self._client.stream(
                "POST",
                f"{self._base_url}/chat/completions",
                json=payload,
                headers={"Authorization": f"Bearer {self._api_key}"},
            ) as response:
                async for line in response.aiter_lines():
                    if not line.startswith("data: "):
                        continue
                    data = line[6:]
                    if data == "[DONE]":
                        yield TextChunk(text="", is_final=True)
                        return
                    try:
                        chunk = json.loads(data)
                        delta = chunk["choices"][0].get("delta", {})
                        content = delta.get("content", "")
                        if content:
                            yield TextChunk(text=content)
                    except (json.JSONDecodeError, KeyError, IndexError):
                        continue
        except httpx.HTTPError as e:
            logger.error(f"LLM请求出错: {e}")
            yield TextChunk(text="哎呀，叽叽脑子转不过来了，再试一次？", is_final=True)

    async def generate(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> str:
        result = []
        async for chunk in self.generate_stream(messages, temperature, max_tokens):
            result.append(chunk.text)
        return "".join(result)

    def _mock_response(self) -> list[TextChunk]:
        """Mock回复 — 模拟叽叽的教学风格"""
        text = (
            "阿姨好呀！叽叽来啦～ "
            "今天咱们学一个买水果的表达，"
            "跟叽叽说一遍：I'd like some apples。"
            "就是\u201c我想要一些苹果\u201d的意思。"
            "来，试试看！"
        )
        words = text.split("，")
        chunks = []
        for i, word in enumerate(words):
            suffix = "，" if i < len(words) - 1 else ""
            chunks.append(TextChunk(text=word + suffix))
        chunks.append(TextChunk(text="", is_final=True))
        return chunks

    async def close(self):
        await self._client.aclose()


class MockLLM(LLMProvider):
    """Mock LLM — 开发调试用，模拟叽叽对话"""

    async def generate_stream(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> AsyncIterator[TextChunk]:
        mock_text = (
            "阿姨好呀！叽叽来啦～ "
            "今天教你一个超实用的，去水果摊买东西的时候可以说："
            "I'd like some apples。"
            "就是\u201c我想要苹果\u201d啦！"
            "来，跟叽叽念一遍？"
        )
        # 模拟流式输出
        for char in mock_text:
            yield TextChunk(text=char)
        yield TextChunk(text="", is_final=True)

    async def generate(
        self, messages: list[ChatMessage], temperature: float = 0.7, max_tokens: int = 500
    ) -> str:
        return (
            "阿姨好呀！叽叽来啦～ "
            "今天教你一个超实用的，去水果摊买东西的时候可以说："
            "I'd like some apples。"
            "就是\u201c我想要苹果\u201d啦！"
            "来，跟叽叽念一遍？"
        )
