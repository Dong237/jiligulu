"""场景API"""
from __future__ import annotations
from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/scenes", tags=["场景"])

# MVP场景数据 — 后续从数据库读取
SCENES = [
    {"id": "s1", "name": "买水果", "name_en": "Buying Fruits", "pack": "starter", "difficulty": 1, "is_free": True,
     "description": "去水果摊买苹果，学会问价和付钱",
     "target_phrases": [
         {"en": "I'd like some apples", "cn": "我想要苹果", "ipa": "/aɪd laɪk sʌm ˈæpəlz/", "xiyin": "爱的 来克 撒姆 爱泡斯"},
         {"en": "How much?", "cn": "多少钱？", "ipa": "/haʊ mʌtʃ/", "xiyin": "好嘛吃"},
         {"en": "Here you go", "cn": "给你", "ipa": "/hɪr juː ɡoʊ/", "xiyin": "嘿儿 优 够"},
     ]},
    {"id": "s2", "name": "打招呼", "name_en": "Greetings", "pack": "starter", "difficulty": 1, "is_free": True,
     "description": "在小区遇到外国邻居，学会打招呼",
     "target_phrases": [
         {"en": "Good morning!", "cn": "早上好！", "ipa": "/ɡʊd ˈmɔːrnɪŋ/", "xiyin": "古德 猫宁"},
         {"en": "How are you?", "cn": "你好吗？", "ipa": "/haʊ ɑːr juː/", "xiyin": "好 啊 优"},
         {"en": "Nice to meet you", "cn": "很高兴认识你", "ipa": "/naɪs tuː miːt juː/", "xiyin": "奈斯 图 米特 优"},
     ]},
    {"id": "s3", "name": "问路", "name_en": "Asking Directions", "pack": "starter", "difficulty": 2, "is_free": True,
     "description": "在街上问路，学会基本方向表达",
     "target_phrases": [
         {"en": "Excuse me", "cn": "打扰一下", "ipa": "/ɪkˈskjuːz miː/", "xiyin": "一颗丝Q斯 咪"},
         {"en": "Where is the bank?", "cn": "银行在哪？", "ipa": "/wɛr ɪz ðə bæŋk/", "xiyin": "维尔 一丝 则 班克"},
         {"en": "Turn left", "cn": "左转", "ipa": "/tɜːrn lɛft/", "xiyin": "特恩 来福特"},
     ]},
    {"id": "s4", "name": "点餐", "name_en": "Ordering Food", "pack": "starter", "difficulty": 2, "is_free": True,
     "description": "在餐厅点菜，学会基本点餐用语",
     "target_phrases": [
         {"en": "Can I have the menu?", "cn": "能给我菜单吗？", "ipa": "/kæn aɪ hæv ðə ˈmɛnjuː/", "xiyin": "坎 爱 嗨五 则 门纽"},
         {"en": "I'll have this one", "cn": "我要这个", "ipa": "/aɪl hæv ðɪs wʌn/", "xiyin": "爱偶 嗨五 迪丝 万"},
         {"en": "The bill, please", "cn": "买单", "ipa": "/ðə bɪl pliːz/", "xiyin": "则 比偶 普利斯"},
     ]},
    {"id": "s5", "name": "超市购物", "name_en": "Shopping", "pack": "starter", "difficulty": 2, "is_free": True,
     "description": "在超市买东西，学会基本购物表达",
     "target_phrases": [
         {"en": "Do you have...?", "cn": "你们有...吗？", "ipa": "/duː juː hæv/", "xiyin": "度 优 嗨五"},
         {"en": "How much is this?", "cn": "这个多少钱？", "ipa": "/haʊ mʌtʃ ɪz ðɪs/", "xiyin": "好嘛吃 一丝 迪丝"},
         {"en": "I'll take it", "cn": "我买了", "ipa": "/aɪl teɪk ɪt/", "xiyin": "爱偶 忒克 一特"},
     ]},
    # 日常场景（会员）
    {"id": "s6", "name": "看医生", "name_en": "Doctor Visit", "pack": "daily", "difficulty": 3, "is_free": False,
     "description": "去诊所看病，学会描述症状",
     "target_phrases": [
         {"en": "I don't feel well", "cn": "我不舒服", "ipa": "/aɪ doʊnt fiːl wɛl/", "xiyin": "爱 东特 飞偶 维偶"},
         {"en": "I have a headache", "cn": "我头疼", "ipa": "/aɪ hæv ə ˈhɛdeɪk/", "xiyin": "爱 嗨五 额 嘿得克"},
     ]},
    {"id": "s7", "name": "坐出租车", "name_en": "Taking a Taxi", "pack": "daily", "difficulty": 2, "is_free": False,
     "description": "打车去目的地",
     "target_phrases": [
         {"en": "Take me to...", "cn": "带我去...", "ipa": "/teɪk miː tuː/", "xiyin": "忒克 咪 图"},
         {"en": "Stop here, please", "cn": "请在这里停", "ipa": "/stɒp hɪr pliːz/", "xiyin": "丝汤普 嘿儿 普利斯"},
     ]},
    {"id": "s8", "name": "酒店入住", "name_en": "Hotel Check-in", "pack": "daily", "difficulty": 3, "is_free": False,
     "description": "在酒店办理入住",
     "target_phrases": [
         {"en": "I have a reservation", "cn": "我有预订", "ipa": "/aɪ hæv ə ˌrɛzərˈveɪʃən/", "xiyin": "爱 嗨五 额 蕊泽维讯"},
         {"en": "Check in, please", "cn": "办入住", "ipa": "/tʃɛk ɪn pliːz/", "xiyin": "切克 因 普利斯"},
     ]},
    {"id": "s9", "name": "打电话", "name_en": "Phone Call", "pack": "daily", "difficulty": 3, "is_free": False,
     "description": "接打英语电话",
     "target_phrases": [
         {"en": "Hello, this is...", "cn": "你好，我是...", "ipa": "/həˈloʊ ðɪs ɪz/", "xiyin": "哈喽 迪丝 一丝"},
         {"en": "Can I speak to...?", "cn": "我能和...说话吗？", "ipa": "/kæn aɪ spiːk tuː/", "xiyin": "坎 爱 丝必克 图"},
     ]},
    {"id": "s10", "name": "公园聊天", "name_en": "Park Chat", "pack": "daily", "difficulty": 2, "is_free": False,
     "description": "在公园和外国人聊天",
     "target_phrases": [
         {"en": "Nice weather today", "cn": "今天天气真好", "ipa": "/naɪs ˈwɛðər təˈdeɪ/", "xiyin": "奈斯 维则 特嘚"},
         {"en": "Do you come here often?", "cn": "你经常来这吗？", "ipa": "/duː juː kʌm hɪr ˈɒfən/", "xiyin": "度 优 卡姆 嘿儿 奥分"},
     ]},
]


class SceneResponse(BaseModel):
    id: str
    name: str
    name_en: str
    pack: str
    difficulty: int
    is_free: bool
    description: str
    target_phrases: list[dict]


@router.get("/")
async def list_scenes():
    """获取所有场景"""
    return {"scenes": SCENES, "total": len(SCENES)}


@router.get("/{scene_id}")
async def get_scene(scene_id: str):
    """获取单个场景详情"""
    for scene in SCENES:
        if scene["id"] == scene_id:
            return scene
    return {"error": "场景不存在"}


@router.get("/{scene_id}/progress")
async def get_scene_progress(scene_id: str):
    """获取场景学习进度（MVP mock）"""
    return {
        "scene_id": scene_id,
        "completed": False,
        "phrases_mastered": 0,
        "total_phrases": 3,
        "last_practiced": None,
    }
