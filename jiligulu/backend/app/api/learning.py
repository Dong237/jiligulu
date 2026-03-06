"""学习进度API"""
from __future__ import annotations
from fastapi import APIRouter

router = APIRouter(prefix="/learning", tags=["学习"])


@router.get("/summary")
async def learning_summary():
    """学习概览（MVP mock数据）"""
    return {
        "today": {"sessions": 1, "minutes": 8, "phrases": 3},
        "week": {"sessions": 5, "minutes": 35, "phrases": 12},
        "total": {"sessions": 15, "phrases": 28, "streak_days": 3},
    }


@router.get("/cards")
async def get_review_cards():
    """获取复习卡片"""
    return {
        "cards": [
            {
                "id": "rc1",
                "session_id": "s001",
                "scene_name": "买水果",
                "learned_at": "2026-03-06",
                "phrases": [
                    {"english": "I'd like some apples", "chinese": "我想要苹果",
                     "phonetic_ipa": "/aɪd laɪk sʌm ˈæpəlz/", "phonetic_chinese": "爱的 来克 撒姆 爱泡斯"},
                    {"english": "How much?", "chinese": "多少钱？",
                     "phonetic_ipa": "/haʊ mʌtʃ/", "phonetic_chinese": "好嘛吃"},
                    {"english": "Here you go", "chinese": "给你",
                     "phonetic_ipa": "/hɪr juː ɡoʊ/", "phonetic_chinese": "嘿儿 优 够"},
                ],
            },
        ],
        "total": 1,
    }


@router.get("/report/weekly")
async def weekly_report():
    """周报"""
    return {
        "period": "2026-03-01 ~ 2026-03-07",
        "sessions": 5,
        "total_minutes": 35,
        "new_phrases": 12,
        "reviewed_phrases": 8,
        "streak_days": 3,
        "pet_stage": "蛋蛋期",
        "pet_xp": 125,
        "highlights": ["学会了买水果", "连续3天打卡"],
    }
