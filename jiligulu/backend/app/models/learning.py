from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import String, Integer, Float, DateTime, ForeignKey, Text, text
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.sql import func

from app.database import Base


class VocabItem(Base):
    __tablename__ = "vocab_items"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()")
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    english: Mapped[str] = mapped_column(String(200), nullable=False)
    chinese: Mapped[str] = mapped_column(String(200), nullable=False)
    phonetic_ipa: Mapped[str | None] = mapped_column(String(200), nullable=True)
    phonetic_chinese: Mapped[str | None] = mapped_column(
        String(200), nullable=True, comment="谐音，方便长辈记"
    )
    srs_level: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    ease_factor: Mapped[float] = mapped_column(Float, default=2.5, server_default=text("2.5"))
    next_review_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    correct_count: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    incorrect_count: Mapped[int] = mapped_column(Integer, default=0, server_default=text("0"))
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )


class ReviewCard(Base):
    __tablename__ = "review_cards"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, server_default=text("gen_random_uuid()")
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    session_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), ForeignKey("sessions.id"), nullable=False
    )
    phrases: Mapped[dict] = mapped_column(JSONB, nullable=False, comment="本次学到的短语列表")
    share_image_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
