"""发音评估 — 可理解度评分（非标准度）"""
from __future__ import annotations
import logging

logger = logging.getLogger(__name__)


def assess_pronunciation(
    user_text: str,
    expected_phrase: str,
) -> dict:
    """评估发音可理解度

    MVP用文本相似度做简单评估，后续接入专业API

    Returns:
        {"score": 0.0-1.0, "level": "great"/"good"/"try_again", "feedback": "..."}
    """
    if not user_text or not expected_phrase:
        return {"score": 0.0, "level": "try_again", "feedback": "叽叽没听清，再说一遍？"}

    # 简单的文本相似度 — MVP够用
    user_lower = user_text.lower().strip()
    expected_lower = expected_phrase.lower().strip()

    if user_lower == expected_lower:
        score = 1.0
    elif expected_lower in user_lower or user_lower in expected_lower:
        score = 0.8
    else:
        # 计算词级别重叠
        user_words = set(user_lower.split())
        expected_words = set(expected_lower.split())
        if expected_words:
            overlap = len(user_words & expected_words) / len(expected_words)
            score = overlap
        else:
            score = 0.3

    if score >= 0.8:
        return {"score": score, "level": "great", "feedback": "说得太棒啦！"}
    elif score >= 0.5:
        return {"score": score, "level": "good", "feedback": "差一点点，再来一次？"}
    else:
        return {"score": score, "level": "try_again", "feedback": "没关系，跟叽叽慢慢念～"}


def filter_filler_words(text: str) -> str:
    """过滤填充词和口头禅"""
    fillers = ["嗯", "啊", "那个", "就是", "然后", "um", "uh", "like", "you know"]
    result = text
    for filler in fillers:
        result = result.replace(filler, "")
    return result.strip()
