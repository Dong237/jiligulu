"""鹦鹉成长系统 — XP计算 + 阶段进化"""
from __future__ import annotations
from dataclasses import dataclass
import logging

logger = logging.getLogger(__name__)

# 6个成长阶段
GROWTH_STAGES = [
    {"stage": 1, "name": "蛋蛋期", "min_xp": 0, "emoji": "\U0001f95a"},
    {"stage": 2, "name": "毛球期", "min_xp": 100, "emoji": "\U0001f423"},
    {"stage": 3, "name": "雏鸟期", "min_xp": 300, "emoji": "\U0001f425"},
    {"stage": 4, "name": "学飞期", "min_xp": 600, "emoji": "\U0001f426"},
    {"stage": 5, "name": "彩羽期", "min_xp": 1000, "emoji": "\U0001f99c"},
    {"stage": 6, "name": "歌唱期", "min_xp": 1500, "emoji": "\U0001f3b5"},
]

# XP奖励规则
XP_REWARDS = {
    "complete_session": 10,      # 完成一次对话
    "new_phrase": 5,             # 学会一个新短语
    "review_phrase": 3,          # 复习一个旧短语
    "daily_streak": 15,          # 连续打卡奖励
    "first_session_today": 5,    # 今天第一次对话
    "perfect_pronunciation": 8,  # 发音完美
}


@dataclass
class PetStatus:
    xp: int = 0
    stage: int = 1
    stage_name: str = "蛋蛋期"

    def add_xp(self, amount: int, reason: str) -> dict:
        """增加XP，检查是否升级"""
        old_stage = self.stage
        self.xp += amount

        # 检查升级
        for stage_info in reversed(GROWTH_STAGES):
            if self.xp >= stage_info["min_xp"]:
                self.stage = stage_info["stage"]
                self.stage_name = stage_info["name"]
                break

        evolved = self.stage > old_stage
        if evolved:
            logger.info(f"叽叽升级啦！{GROWTH_STAGES[old_stage-1]['name']} -> {self.stage_name}")

        return {
            "xp_gained": amount,
            "reason": reason,
            "total_xp": self.xp,
            "stage": self.stage,
            "stage_name": self.stage_name,
            "evolved": evolved,
        }

    def get_next_stage_xp(self) -> int:
        """下一阶段需要的XP"""
        for stage_info in GROWTH_STAGES:
            if stage_info["stage"] > self.stage:
                return stage_info["min_xp"]
        return self.xp  # 已满级

    def to_dict(self) -> dict:
        return {
            "xp": self.xp,
            "stage": self.stage,
            "stage_name": self.stage_name,
            "next_stage_xp": self.get_next_stage_xp(),
            "emoji": GROWTH_STAGES[self.stage - 1]["emoji"],
        }


def calculate_session_xp(
    phrases_taught: int,
    phrases_reviewed: int,
    is_first_today: bool,
    streak_days: int,
    perfect_count: int = 0,
) -> list[dict]:
    """计算一次对话获得的XP明细"""
    rewards = []

    rewards.append({
        "type": "complete_session",
        "xp": XP_REWARDS["complete_session"],
        "label": "完成对话",
    })

    for _ in range(phrases_taught):
        rewards.append({
            "type": "new_phrase",
            "xp": XP_REWARDS["new_phrase"],
            "label": "学了新短语",
        })

    for _ in range(phrases_reviewed):
        rewards.append({
            "type": "review_phrase",
            "xp": XP_REWARDS["review_phrase"],
            "label": "复习旧短语",
        })

    if is_first_today:
        rewards.append({
            "type": "first_session_today",
            "xp": XP_REWARDS["first_session_today"],
            "label": "今天第一次",
        })

    if streak_days >= 3:
        rewards.append({
            "type": "daily_streak",
            "xp": XP_REWARDS["daily_streak"],
            "label": f"连续{streak_days}天",
        })

    for _ in range(perfect_count):
        rewards.append({
            "type": "perfect_pronunciation",
            "xp": XP_REWARDS["perfect_pronunciation"],
            "label": "发音完美",
        })

    return rewards
