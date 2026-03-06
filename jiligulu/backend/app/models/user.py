from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import String, Integer, Float, DateTime, ForeignKey, Text, text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()")
    )
    phone: Mapped[str | None] = mapped_column(String(20), unique=True, nullable=True)
    role: Mapped[str] = mapped_column(String(10), comment="elder / child")
    display_name: Mapped[str | None] = mapped_column(String(50), nullable=True)
    gender: Mapped[str | None] = mapped_column(String(10), nullable=True)
    english_level: Mapped[int] = mapped_column(Integer, default=1, server_default=text("1"))
    learning_goal: Mapped[str | None] = mapped_column(Text, nullable=True)
    pet_xp: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    pet_stage: Mapped[int] = mapped_column(Integer, default=1, server_default=text("1"))
    streak_days: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    last_active_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    subscription_type: Mapped[str] = mapped_column(
        String(20), default="trial", server_default=text("'trial'")
    )
    password_hash: Mapped[str | None] = mapped_column(
        String(128), nullable=True, comment="小孩账号密码，长辈用手机验证码"
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class Family(Base):
    __tablename__ = "families"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()")
    )
    child_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    elder_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    relationship: Mapped[str] = mapped_column(
        String(20), default="parent", server_default=text("'parent'")
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
