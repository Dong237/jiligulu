"""分享卡片生成 — 服务端渲染PNG图片"""
from __future__ import annotations
import logging

logger = logging.getLogger(__name__)


class ShareService:
    """生成分享卡片图片

    MVP阶段返回mock数据，Phase 6完整版用Pillow渲染750x1334 PNG
    """

    async def generate_share_card(
        self,
        card_type: str,  # "review" | "weekly_report" | "milestone"
        data: dict,
    ) -> dict:
        """生成分享卡片

        Returns: {"image_url": "...", "share_text": "..."}
        """
        # MVP: 返回placeholder
        if card_type == "review":
            phrases = data.get("phrases", [])
            phrase_text = "、".join(p.get("english", "") for p in phrases[:3])
            share_text = f"我今天跟小鹦鹉叽叽学了 {phrase_text}！快来一起学英语吧～"
        elif card_type == "weekly_report":
            sessions = data.get("sessions", 0)
            phrases = data.get("new_phrases", 0)
            share_text = f"妈妈这周和叽叽聊了{sessions}次，学了{phrases}个新表达！"
        elif card_type == "milestone":
            milestone = data.get("description", "")
            share_text = f"叽叽达成新成就：{milestone}"
        else:
            share_text = "来叽里咕噜和小鹦鹉一起学英语吧！"

        logger.info(f"生成分享卡片: type={card_type}")
        return {
            "image_url": "https://placeholder.jiligulu.com/share-card.png",
            "share_text": share_text,
            "card_type": card_type,
        }
