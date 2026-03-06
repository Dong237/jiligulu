from __future__ import annotations

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """叽里咕噜后端配置，优先从 .env 读取"""

    model_config = SettingsConfigDict(env_file=".env")

    # 数据库
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/jiligulu"
    REDIS_URL: str = "redis://localhost:6379/0"

    # JWT 认证
    JWT_SECRET: str = "dev-secret-change-me"
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRE_MINUTES: int = 1440  # 24 小时

    # AI 服务商
    ASR_PROVIDER: str = "aliyun"
    LLM_PROVIDER: str = "doubao"
    TTS_PROVIDER: str = "doubao"

    # 阿里云 ASR
    ALIYUN_ASR_KEY: str = ""
    ALIYUN_ASR_SECRET: str = ""

    # 豆包
    DOUBAO_API_KEY: str = ""
    DOUBAO_TTS_KEY: str = ""

    # 调试模式
    DEBUG: bool = True


settings = Settings()
