from __future__ import annotations

from collections.abc import AsyncGenerator

import aioredis
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import declarative_base

from app.config import settings

# 异步引擎 & 会话工厂
engine = create_async_engine(settings.DATABASE_URL, echo=settings.DEBUG)
async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# 模型基类
Base = declarative_base()


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """每次请求拿一个数据库会话，用完自动关"""
    async with async_session() as session:
        yield session


async def get_redis() -> aioredis.Redis:
    """拿一个 Redis 连接"""
    return aioredis.from_url(settings.REDIS_URL, decode_responses=True)
