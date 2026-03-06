"""三层记忆系统 — 让叽叽记住用户

1. 短期记忆 (SessionMemory): 单次对话内
2. 长期记忆 (UserProfile): 跨会话个人信息
3. 学习记忆 (SRS): 词汇间隔重复
"""
from __future__ import annotations
from dataclasses import dataclass, field
import json
import logging

logger = logging.getLogger(__name__)


@dataclass
class SessionMemory:
    """短期记忆 — 一次对话内的上下文

    MVP阶段用内存存储，后续切换到Redis
    """
    session_id: str = ""
    phrases_taught: list[dict] = field(default_factory=list)
    phrases_reviewed: list[str] = field(default_factory=list)
    user_mood: str = "neutral"  # positive / neutral / frustrated
    turn_count: int = 0
    corrections_count: int = 0

    def record_phrase_taught(self, phrase: dict):
        self.phrases_taught.append(phrase)

    def record_mood(self, mood: str):
        self.user_mood = mood

    def increment_turn(self):
        self.turn_count += 1

    def to_context(self) -> str:
        """转为LLM上下文文本"""
        parts = [f"本次对话已进行{self.turn_count}轮。"]
        if self.phrases_taught:
            taught = ", ".join(p.get("en", "") for p in self.phrases_taught)
            parts.append(f"已教的短语：{taught}")
        if self.user_mood == "frustrated":
            parts.append("用户可能有些困难，请更耐心，降低难度。")
        return " ".join(parts)


@dataclass
class UserProfile:
    """长期记忆 — 跨会话的用户画像

    MVP阶段用内存，后续从PostgreSQL读取
    """
    user_id: str = ""
    display_name: str = ""
    gender: str = "female"
    english_level: int = 1  # 1-5
    learning_goal: str = ""
    personal_notes: list[str] = field(default_factory=list)  # LLM提取的个人信息
    favorite_topics: list[str] = field(default_factory=list)
    total_sessions: int = 0
    total_phrases: int = 0

    def to_context(self) -> str:
        """转为LLM上下文文本"""
        title = "阿姨" if self.gender == "female" else "叔叔"
        parts = [f"用户{self.display_name or ''}，称呼{title}。"]
        parts.append(f"英语水平{self.english_level}级，已学{self.total_phrases}个短语。")
        if self.learning_goal:
            parts.append(f"学习目标：{self.learning_goal}")
        if self.personal_notes:
            parts.append(f"个人信息：{'、'.join(self.personal_notes[:5])}")
        return " ".join(parts)


class PromptContextBuilder:
    """组装完整的LLM上下文

    顺序：System Prompt -> 用户画像 -> 场景信息 -> 会话状态 -> 复习词汇注入
    """

    def __init__(self, base_system_prompt: str):
        self.base_prompt = base_system_prompt

    def build(
        self,
        user_profile: UserProfile | None = None,
        session_memory: SessionMemory | None = None,
        scene_name: str | None = None,
        scene_prompt: str | None = None,
        review_phrases: list[dict] | None = None,
    ) -> str:
        sections = [self.base_prompt]

        if user_profile:
            sections.append(f"\n## 用户画像\n{user_profile.to_context()}")

        if scene_name and scene_prompt:
            sections.append(f"\n## 当前场景：{scene_name}\n{scene_prompt}")

        if review_phrases:
            phrases_text = "、".join(p.get("en", "") for p in review_phrases)
            sections.append(
                f"\n## 复习任务\n请在对话中自然带出这些之前学过的短语：{phrases_text}。"
                "不要说'来复习一下'，而是自然融入对话情境中。"
            )

        if session_memory:
            sections.append(f"\n## 当前对话状态\n{session_memory.to_context()}")

        return "\n".join(sections)
