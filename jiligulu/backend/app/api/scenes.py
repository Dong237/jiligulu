from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/scenes", tags=["场景"])


@router.get("/")
async def list_scenes():
    """拿到所有场景列表"""
    return []


@router.get("/{scene_id}/progress")
async def scene_progress(scene_id: str):
    """查看某个场景的学习进度"""
    return {"scene_id": scene_id, "progress": 0}
