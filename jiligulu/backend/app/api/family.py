from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/family", tags=["家庭"])


@router.get("/dashboard")
async def family_dashboard():
    """家庭管理面板，长辈查看小孩学习情况"""
    return {"members": []}


@router.post("/gift")
async def send_gift():
    """长辈给小孩送订阅/礼物"""
    return {"msg": "礼物已发送"}
