"""家庭管理API — 子女仪表盘"""
from __future__ import annotations
from fastapi import APIRouter

router = APIRouter(prefix="/family", tags=["家庭"])


@router.get("/dashboard")
async def family_dashboard():
    """子女仪表盘 — 查看父母学习进展"""
    return {
        "elder_name": "妈妈",
        "week_overview": {
            "sessions": 5,
            "minutes": 35,
            "new_phrases": 12,
            "streak_days": 3,
        },
        "pet": {
            "stage_name": "毛球期",
            "xp": 125,
            "next_stage_xp": 300,
        },
        "recent_phrases": [
            {"english": "Good morning!", "chinese": "早上好！"},
            {"english": "How much?", "chinese": "多少钱？"},
            {"english": "Thank you!", "chinese": "谢谢！"},
        ],
        "message": "妈妈这周学得可认真了！",
    }


@router.get("/report/weekly")
async def weekly_report():
    """周报详情"""
    return {
        "period": "2026-03-01 ~ 2026-03-07",
        "elder_name": "妈妈",
        "sessions": 5,
        "total_minutes": 35,
        "new_phrases": 12,
        "reviewed_phrases": 8,
        "streak_days": 3,
        "pet_stage": "毛球期",
        "favorite_scene": "买水果",
        "highlights": [
            "学会了和水果摊老板对话",
            "连续3天坚持学习",
            "叽叽从蛋蛋期进化到毛球期了！",
        ],
    }


@router.post("/gift")
async def send_gift():
    """赠送场景包（MVP placeholder）"""
    return {"message": "场景包赠送成功！妈妈下次打开就能看到了～"}


@router.post("/verify-password")
async def verify_password(password: str = "1234"):
    """验证子女端密码"""
    if password == "1234":
        return {"valid": True, "message": "验证通过"}
    return {"valid": False, "message": "密码不对哦，这是家人管理的入口"}
