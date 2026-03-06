"""内容安全过滤 — 确保LLM输出适合老年用户"""
from __future__ import annotations
import re
import logging

logger = logging.getLogger(__name__)

# 敏感词列表
BLOCKED_TOPICS = [
    "政治", "选举", "党", "主席",
    "宗教", "信仰", "佛", "基督",
    "性", "色情",
    "赌博", "博彩",
    "毒品", "吸毒",
    "自杀", "自残",
    "暴力", "杀",
]

# 负面词汇（叽叽不该说的）
NEGATIVE_WORDS = [
    "错了", "不对", "不行", "笨", "蠢", "差劲",
    "wrong", "stupid", "bad", "terrible", "awful",
]

SAFE_REPLACEMENT = "哎呀叽叽说溜嘴了，咱们继续学英语吧！"


def filter_content(text: str) -> tuple[str, bool]:
    """过滤不安全内容

    Returns: (filtered_text, was_filtered)
    """
    text_lower = text.lower()

    # 检查敏感话题
    for topic in BLOCKED_TOPICS:
        if topic in text_lower:
            logger.warning(f"内容安全过滤触发: 包含敏感词 '{topic}'")
            return SAFE_REPLACEMENT, True

    # 过滤负面词汇
    filtered = text
    was_filtered = False
    for word in NEGATIVE_WORDS:
        if word in filtered:
            filtered = filtered.replace(word, "")
            was_filtered = True

    if was_filtered:
        logger.info("过滤了负面词汇")

    return filtered.strip() or SAFE_REPLACEMENT, was_filtered


def is_off_topic(text: str) -> str | None:
    """检测是否偏离英语学习话题

    Returns: 引导回话语 or None
    """
    off_topic_signals = ["身体不舒服", "生病", "头疼", "孤独", "寂寞", "想孩子"]

    for signal in off_topic_signals:
        if signal in text:
            if "病" in signal or "疼" in signal or "不舒服" in signal:
                return "阿姨身体不舒服要注意休息哦！等好了叽叽再陪你聊～现在要不要学个简单的？"
            return "叽叽理解的！不过叽叽最擅长教英语啦，来学个新的表达转换一下心情？"

    return None
