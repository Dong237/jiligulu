from __future__ import annotations

import logging

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(name)s] %(message)s")

from contextlib import asynccontextmanager
from collections.abc import AsyncGenerator

import aioredis
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.api.auth import router as auth_router
from app.api.voice import router as voice_router
from app.api.scenes import router as scenes_router
from app.api.learning import router as learning_router
from app.api.family import router as family_router
from app.api.pet import router as pet_router
from app.api.share import router as share_router

logger = logging.getLogger("jiligulu")


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    # 启动
    logger.info("叽里咕噜后端启动")
    app.state.redis = aioredis.from_url(settings.REDIS_URL, decode_responses=True)
    yield
    # 关闭
    await app.state.redis.close()
    logger.info("叽里咕噜后端已关闭")


app = FastAPI(
    title="叽里咕噜",
    description="AI 英语学习助手后端",
    version="0.1.0",
    lifespan=lifespan,
)

# 开发阶段先放开跨域
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 挂载路由
app.include_router(auth_router, prefix="/api/v1")
app.include_router(voice_router, prefix="/api/v1")
app.include_router(scenes_router, prefix="/api/v1")
app.include_router(learning_router, prefix="/api/v1")
app.include_router(family_router, prefix="/api/v1")
app.include_router(pet_router, prefix="/api/v1")
app.include_router(share_router, prefix="/api/v1")


@app.get("/")
async def root():
    return {"app": "叽里咕噜", "version": "0.1.0"}


@app.get("/health")
async def health():
    return {"status": "ok"}
