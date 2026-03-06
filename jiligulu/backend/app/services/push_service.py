"""推送服务 — 每日邀约 + 周报 + 回流"""
from __future__ import annotations
from dataclasses import dataclass
from datetime import datetime
import logging

logger = logging.getLogger(__name__)


@dataclass
class PushMessage:
    user_id: str
    title: str
    body: str
    push_type: str  # daily_invite / weekly_report / winback
    deep_link: str = ""


class PushService:
    """推送服务抽象层

    MVP阶段只记录日志，后续接入极光推送/Firebase
    """

    async def send(self, message: PushMessage) -> bool:
        """发送推送"""
        logger.info(
            f"[推送] {message.push_type} -> {message.user_id}: "
            f"{message.title} | {message.body}"
        )
        # MVP: 只记录，不实际发送
        return True

    async def send_daily_invite(
        self,
        user_id: str,
        user_name: str,
        last_phrase: str | None = None,
    ) -> bool:
        """每日邀约推送 — 个性化内容"""
        if last_phrase:
            body = f"叽叽想和你练练昨天学的 {last_phrase} 呢！来聊两句？"
        else:
            body = f"{user_name}，叽叽想你啦！来学个新表达？"

        return await self.send(PushMessage(
            user_id=user_id,
            title="叽叽喊你来聊天～",
            body=body,
            push_type="daily_invite",
            deep_link="jiligulu://voice-chat",
        ))

    async def send_weekly_report(
        self,
        child_user_id: str,
        elder_name: str,
        sessions: int,
        new_phrases: int,
    ) -> bool:
        """子女周报推送"""
        return await self.send(PushMessage(
            user_id=child_user_id,
            title=f"{elder_name}的学习周报来啦！",
            body=f"{elder_name}这周和叽叽聊了{sessions}次，学了{new_phrases}个新词！",
            push_type="weekly_report",
            deep_link="jiligulu://child/report",
        ))

    async def send_winback(
        self,
        user_id: str,
        user_name: str,
        days_inactive: int,
    ) -> bool:
        """回流推送 — 最多3次"""
        messages = {
            3: f"{user_name}，叽叽3天没见到你了，有点想你～",
            7: f"{user_name}，叽叽学了个新本领想给你看！来吗？",
            14: f"{user_name}，叽叽还记得你呢！随时欢迎回来聊天～",
        }
        body = messages.get(days_inactive, f"叽叽在等你呢，{user_name}！")

        return await self.send(PushMessage(
            user_id=user_id,
            title="叽叽想你啦",
            body=body,
            push_type="winback",
            deep_link="jiligulu://voice-chat",
        ))
