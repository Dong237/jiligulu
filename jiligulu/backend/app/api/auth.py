from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/auth", tags=["认证"])


@router.post("/register")
async def register():
    """注册新用户（小孩账号）"""
    return {"msg": "注册成功"}


@router.post("/create-elder")
async def create_elder():
    """创建长辈账号"""
    return {"msg": "长辈账号创建成功"}


@router.post("/elder-login")
async def elder_login():
    """长辈手机号登录"""
    return {"msg": "登录成功"}


@router.post("/token/refresh")
async def refresh_token():
    """刷新 JWT token"""
    return {"msg": "token 已刷新"}
