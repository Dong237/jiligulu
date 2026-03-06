"""语音对话 WebSocket 端点 — App的主通道"""
from __future__ import annotations
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
import json
import base64
import logging

from ..services.voice_pipeline import VoicePipeline, PipelineConfig
from ..services.llm_service import ChatMessage as LLMMessage, MockLLM
from ..services.asr_service import MockASR
from ..services.tts_service import MockTTS
from ..prompts.system_prompt import build_system_prompt

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/voice", tags=["语音对话"])


def get_pipeline() -> VoicePipeline:
    """创建语音管线实例

    MVP阶段用Mock实现，后续替换为真实API
    """
    return VoicePipeline(
        asr=MockASR(),
        llm=MockLLM(),
        tts=MockTTS(),
    )


@router.websocket("/session")
async def voice_session(websocket: WebSocket):
    """语音对话 WebSocket 端点

    客户端消息格式:
    - {"type": "audio_chunk", "data": "<base64 PCM>"}
    - {"type": "control", "action": "start" | "end" | "interrupt"}

    服务端消息格式:
    - {"type": "transcript", "data": {"text": "...", "is_final": true}}
    - {"type": "response_text", "data": {"text": "...", "is_final": false}}
    - {"type": "response_audio", "data": {"audio": "<base64>", "sample_rate": 24000}}
    - {"type": "session_summary", "data": {...}}
    - {"type": "error", "data": {"message": "..."}}
    """
    await websocket.accept()
    logger.info("语音对话WebSocket已连接")

    pipeline = get_pipeline()
    conversation_history: list[LLMMessage] = []
    system_prompt = build_system_prompt()
    audio_buffer = bytearray()

    try:
        while True:
            raw = await websocket.receive_text()
            try:
                msg = json.loads(raw)
            except json.JSONDecodeError:
                await websocket.send_json({
                    "type": "error",
                    "data": {"message": "消息格式不对哦"}
                })
                continue

            msg_type = msg.get("type")

            if msg_type == "audio_chunk":
                # 收集音频数据
                audio_b64 = msg.get("data", "")
                try:
                    audio_bytes = base64.b64decode(audio_b64)
                    audio_buffer.extend(audio_bytes)
                except Exception:
                    pass

            elif msg_type == "control":
                action = msg.get("action")

                if action == "start":
                    audio_buffer.clear()
                    await websocket.send_json({
                        "type": "control",
                        "data": {"status": "recording"}
                    })

                elif action == "end":
                    # 用户松开说话按钮，开始处理
                    if not audio_buffer:
                        await websocket.send_json({
                            "type": "error",
                            "data": {"message": "叽叽没听到声音，再试试？"}
                        })
                        continue

                    # 走管线: ASR → LLM → TTS
                    async for event in pipeline.process_audio(
                        audio_data=bytes(audio_buffer),
                        conversation_history=conversation_history,
                        system_prompt=system_prompt,
                    ):
                        await websocket.send_json({
                            "type": event.type,
                            "data": event.data,
                        })

                        # 记录对话历史
                        if event.type == "transcript" and event.data.get("is_final"):
                            conversation_history.append(
                                LLMMessage(role="user", content=event.data["text"])
                            )
                        elif event.type == "response_text" and event.data.get("is_final"):
                            full_text = event.data.get("full_text", "")
                            if full_text:
                                conversation_history.append(
                                    LLMMessage(role="assistant", content=full_text)
                                )

                    audio_buffer.clear()

                elif action == "interrupt":
                    # 用户打断，清空当前处理
                    audio_buffer.clear()
                    await websocket.send_json({
                        "type": "control",
                        "data": {"status": "interrupted"}
                    })

    except WebSocketDisconnect:
        logger.info("语音对话WebSocket断开")
    except Exception as e:
        logger.error(f"WebSocket异常: {e}")
    finally:
        await pipeline.close()


@router.post("/session/start")
async def start_session():
    """开始语音对话（HTTP，获取session信息）"""
    return {
        "session_id": "mock-session-001",
        "ws_url": "/api/v1/voice/session",
        "message": "叽叽准备好了！"
    }


@router.post("/session/end")
async def end_session():
    """结束语音对话（HTTP）"""
    return {
        "message": "对话结束啦，叽叽下次见！",
        "summary": {
            "duration_seconds": 300,
            "phrases_taught": 3,
            "xp_earned": 25,
        }
    }
