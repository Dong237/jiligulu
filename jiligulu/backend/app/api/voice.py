from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/voice", tags=["语音对话"])


@router.post("/session/start")
async def start_session():
    """开始一轮语音对话"""
    return {"msg": "对话已开始"}


@router.post("/session/end")
async def end_session():
    """结束当前对话"""
    return {"msg": "对话已结束"}


# WebSocket 端点会在 Phase 2 加上
