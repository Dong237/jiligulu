"""学习引擎 — SRS间隔重复 + 复习卡片生成"""
from __future__ import annotations
from dataclasses import dataclass
from datetime import datetime, timedelta
import math
import logging

logger = logging.getLogger(__name__)


@dataclass
class SRSItem:
    """SRS词汇项"""
    english: str
    chinese: str
    phonetic_ipa: str = ""
    phonetic_chinese: str = ""
    srs_level: int = 0
    ease_factor: float = 2.5
    next_review: datetime | None = None
    correct_count: int = 0
    incorrect_count: int = 0

    def calculate_next_review(self, quality: int) -> datetime:
        """改良SM-2算法 — 老年人版（间隔比标准短30-50%）

        quality: 0-5评分
          0-2: 忘记了
          3: 勉强记住
          4: 记住了
          5: 轻松记住
        """
        # 调整ease factor
        self.ease_factor = max(
            1.3,
            self.ease_factor + 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02)
        )

        if quality < 3:
            # 忘了 — 不完全重置（避免挫败感），降一级
            self.srs_level = max(0, self.srs_level - 1)
            self.incorrect_count += 1
        else:
            self.srs_level += 1
            self.correct_count += 1

        # 标准SM-2间隔
        if self.srs_level == 0:
            interval_days = 0.5  # 12小时后
        elif self.srs_level == 1:
            interval_days = 1
        elif self.srs_level == 2:
            interval_days = 3
        else:
            interval_days = self.ease_factor ** (self.srs_level - 1)

        # 老年人调整：间隔缩短30-50%
        elder_factor = 0.6  # 比标准短40%
        interval_days *= elder_factor

        self.next_review = datetime.utcnow() + timedelta(days=interval_days)
        return self.next_review


def generate_review_card(
    session_id: str,
    phrases: list[dict],
    scene_name: str,
) -> dict:
    """从对话中生成复习卡片"""
    return {
        "session_id": session_id,
        "scene_name": scene_name,
        "learned_at": datetime.utcnow().isoformat(),
        "phrases": [
            {
                "english": p.get("en", p.get("english", "")),
                "chinese": p.get("cn", p.get("chinese", "")),
                "phonetic_ipa": p.get("ipa", p.get("phonetic_ipa", "")),
                "phonetic_chinese": p.get("xiyin", p.get("phonetic_chinese", "")),
            }
            for p in phrases
        ],
    }
