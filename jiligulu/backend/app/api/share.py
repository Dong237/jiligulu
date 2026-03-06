from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/share", tags=["分享"])


@router.post("/card")
async def generate_share_card():
    """生成分享卡片图片"""
    return {"msg": "卡片生成中"}
