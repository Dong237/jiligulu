"""叽叽鹦鹉状态API"""
from __future__ import annotations
from fastapi import APIRouter

router = APIRouter(prefix="/pet", tags=["叽叽"])

# 成长阶段定义
GROWTH_STAGES = [
    {"stage": 1, "name": "蛋蛋期", "min_xp": 0, "description": "叽叽还是一颗蛋，等你来孵化～"},
    {"stage": 2, "name": "毛球期", "min_xp": 100, "description": "叽叽破壳啦！毛绒绒的小家伙"},
    {"stage": 3, "name": "雏鸟期", "min_xp": 300, "description": "叽叽长出了小翅膀！"},
    {"stage": 4, "name": "学飞期", "min_xp": 600, "description": "叽叽在练习飞翔呢"},
    {"stage": 5, "name": "彩羽期", "min_xp": 1000, "description": "叽叽的羽毛变得五彩缤纷！"},
    {"stage": 6, "name": "歌唱期", "min_xp": 1500, "description": "叽叽会唱英语歌啦！"},
]


@router.get("/status")
async def pet_status():
    """叽叽当前状态"""
    return {
        "xp": 125,
        "stage": 2,
        "stage_name": "毛球期",
        "next_stage_xp": 300,
        "description": "叽叽破壳啦！毛绒绒的小家伙",
        "streak_days": 3,
    }


@router.get("/milestones")
async def pet_milestones():
    """叽叽成长里程碑"""
    return {
        "milestones": [
            {"day": 1, "description": "叽叽破壳啦！", "achieved": True},
            {"day": 3, "description": "连续学习3天，叽叽开始认识你了", "achieved": True},
            {"day": 7, "description": "一周啦！叽叽长出了小翅膀", "achieved": False},
            {"day": 14, "description": "叽叽学会了第一首英语歌", "achieved": False},
            {"day": 30, "description": "叽叽能和你用英语聊天了！", "achieved": False},
        ],
        "growth_stages": GROWTH_STAGES,
    }
