from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/pet", tags=["叽叽"])


@router.get("/status")
async def pet_status():
    """获取宠物叽叽的当前状态"""
    return {"stage": 1, "xp": 0, "mood": "开心"}


@router.get("/milestones")
async def pet_milestones():
    """获取宠物成长里程碑"""
    return []
