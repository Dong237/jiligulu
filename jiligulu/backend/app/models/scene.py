from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import String, Integer, Boolean, DateTime, Text, text
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.database import Base


class Scene(Base):
    __tablename__ = "scenes"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()")
    )
    name: Mapped[str] = mapped_column(String(100), nullable=False, comment="场景中文名")
    name_en: Mapped[str] = mapped_column(String(100), nullable=False, comment="场景英文名")
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    pack: Mapped[str] = mapped_column(
        String(20), nullable=False, comment="starter / daily / travel / family"
    )
    difficulty: Mapped[int] = mapped_column(Integer, nullable=False, comment="1-5 难度")
    target_phrases: Mapped[dict] = mapped_column(JSONB, nullable=False, comment="目标短语列表")
    scene_prompt: Mapped[str | None] = mapped_column(Text, nullable=True, comment="给 LLM 的场景提示词")
    is_free: Mapped[bool] = mapped_column(Boolean, default=False, server_default=text("false"))
    sort_order: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
