from __future__ import annotations

from fastapi import APIRouter

router = APIRouter(prefix="/learning", tags=["学习"])


@router.get("/summary")
async def learning_summary():
    """学习概览数据"""
    return {"total_phrases": 0, "streak_days": 0, "xp": 0}


@router.get("/cards")
async def review_cards():
    """获取复习卡片列表"""
    return []


@router.get("/report/weekly")
async def weekly_report():
    """本周学习报告"""
    return {"week": "", "sessions": 0, "phrases_learned": 0}
