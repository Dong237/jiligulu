"""分享API"""
from __future__ import annotations
from fastapi import APIRouter
from pydantic import BaseModel
from ..services.share_service import ShareService

router = APIRouter(prefix="/share", tags=["分享"])
share_service = ShareService()


class ShareCardRequest(BaseModel):
    card_type: str = "review"  # review / weekly_report / milestone
    data: dict = {}


@router.post("/card")
async def generate_share_card(req: ShareCardRequest):
    """生成分享卡片"""
    result = await share_service.generate_share_card(req.card_type, req.data)
    return result
