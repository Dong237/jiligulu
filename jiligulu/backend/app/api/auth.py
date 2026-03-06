"""认证API — 子女注册 + 老人扫码登录"""
from __future__ import annotations
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from datetime import datetime, timedelta
from jose import jwt
import uuid
import logging

from ..config import settings

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/auth", tags=["认证"])

# MVP内存存储 — 后续切换到数据库
_users: dict[str, dict] = {}
_qr_tokens: dict[str, dict] = {}


class RegisterRequest(BaseModel):
    phone: str
    password: str
    display_name: str | None = None


class CreateElderRequest(BaseModel):
    display_name: str
    gender: str = "female"  # female / male
    english_level: int = 1
    learning_goal: str = ""


class ElderLoginRequest(BaseModel):
    qr_token: str


def _create_token(user_id: str, role: str) -> str:
    payload = {
        "sub": user_id,
        "role": role,
        "exp": datetime.utcnow() + timedelta(minutes=settings.JWT_EXPIRE_MINUTES),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)


@router.post("/register")
async def register(req: RegisterRequest):
    """子女注册（手机号+密码）"""
    if req.phone in {u.get("phone") for u in _users.values()}:
        raise HTTPException(400, "这个手机号已经注册过了")

    user_id = str(uuid.uuid4())
    _users[user_id] = {
        "id": user_id,
        "phone": req.phone,
        "role": "child",
        "display_name": req.display_name or f"用户{req.phone[-4:]}",
        "created_at": datetime.utcnow().isoformat(),
    }

    token = _create_token(user_id, "child")
    logger.info(f"子女注册成功: {req.phone}")
    return {
        "user_id": user_id,
        "token": token,
        "role": "child",
        "message": "注册成功！现在帮爸妈设置吧～",
    }


@router.post("/create-elder")
async def create_elder(req: CreateElderRequest):
    """子女为老人创建账号（无需密码）"""
    elder_id = str(uuid.uuid4())
    title = "阿姨" if req.gender == "female" else "叔叔"

    _users[elder_id] = {
        "id": elder_id,
        "role": "elder",
        "display_name": req.display_name,
        "gender": req.gender,
        "english_level": req.english_level,
        "learning_goal": req.learning_goal,
        "created_at": datetime.utcnow().isoformat(),
    }

    # 生成扫码登录用的QR token
    qr_token = str(uuid.uuid4())[:8]
    _qr_tokens[qr_token] = {
        "elder_id": elder_id,
        "expires_at": (datetime.utcnow() + timedelta(hours=24)).isoformat(),
    }

    logger.info(f"老人账号创建成功: {req.display_name}({title})")
    return {
        "elder_id": elder_id,
        "qr_token": qr_token,
        "qr_content": f"jiligulu://login?token={qr_token}",
        "message": f"好啦！让{title}扫这个二维码就能登录了",
    }


@router.post("/elder-login")
async def elder_login(req: ElderLoginRequest):
    """老人扫码登录"""
    qr_data = _qr_tokens.get(req.qr_token)
    if not qr_data:
        raise HTTPException(400, "二维码过期了，让孩子重新生成一个吧")

    elder_id = qr_data["elder_id"]
    elder = _users.get(elder_id)
    if not elder:
        raise HTTPException(400, "账号不存在")

    token = _create_token(elder_id, "elder")
    logger.info(f"老人扫码登录成功: {elder.get('display_name')}")
    return {
        "user_id": elder_id,
        "token": token,
        "role": "elder",
        "display_name": elder.get("display_name", ""),
        "message": "叽叽在等你呢！",
    }


@router.post("/token/refresh")
async def refresh_token():
    """刷新Token（MVP简化版）"""
    # MVP: 直接返回一个新token
    new_token = _create_token("mock-user", "elder")
    return {"token": new_token}
