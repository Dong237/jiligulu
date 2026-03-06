import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/chat_message.dart';
import '../../shared/widgets/pet_animation_widget.dart';
import 'widgets/talk_button.dart';

class VoiceChatState {
  final List<ChatMessage> messages;
  final bool isRecording;
  final bool isProcessing;
  final bool isStreaming;
  final PetAnimationState petState;
  final TalkButtonState talkButtonState;

  const VoiceChatState({
    this.messages = const [],
    this.isRecording = false,
    this.isProcessing = false,
    this.isStreaming = false,
    this.petState = PetAnimationState.greeting,
    this.talkButtonState = TalkButtonState.idle,
  });

  VoiceChatState copyWith({
    List<ChatMessage>? messages,
    bool? isRecording,
    bool? isProcessing,
    bool? isStreaming,
    PetAnimationState? petState,
    TalkButtonState? talkButtonState,
  }) {
    return VoiceChatState(
      messages: messages ?? this.messages,
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      isStreaming: isStreaming ?? this.isStreaming,
      petState: petState ?? this.petState,
      talkButtonState: talkButtonState ?? this.talkButtonState,
    );
  }
}

class VoiceChatController extends StateNotifier<VoiceChatState> {
  VoiceChatController() : super(const VoiceChatState()) {
    // 叽叽打招呼
    _addAssistantMessage('阿姨好呀！叽叽来啦~ 今天想学点什么？按住下面的按钮跟我说话吧！');
  }

  void startRecording() {
    state = state.copyWith(
      isRecording: true,
      petState: PetAnimationState.teaching,
      talkButtonState: TalkButtonState.recording,
    );
    // TODO: Phase 2 完整实现 — 开始录音 + WebSocket发送音频
  }

  void stopRecording() {
    state = state.copyWith(
      isRecording: false,
      isProcessing: true,
      petState: PetAnimationState.thinking,
      talkButtonState: TalkButtonState.processing,
    );

    // 模拟处理 — Phase 2 替换为真实WebSocket交互
    _simulateResponse();
  }

  void sendQuickReply(String reply) {
    _addUserMessage(reply);
    state = state.copyWith(
      isProcessing: true,
      petState: PetAnimationState.thinking,
    );
    _simulateResponse();
  }

  void _simulateResponse() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      final responses = [
        '说得很棒！来试试这个：How much? 就是"多少钱"的意思~ 谐音可以记成"好嘛吃"',
        '差一点点！没关系，跟叽叽再来一次：I would like 就是"我想要"~',
        '太厉害啦！那咱们学个新的：Thank you! 谢谢~ 这个阿姨肯定会！',
      ];

      final index = state.messages.length % responses.length;
      _addAssistantMessage(responses[index]);

      state = state.copyWith(
        isProcessing: false,
        petState: PetAnimationState.happy,
        talkButtonState: TalkButtonState.idle,
      );

      // 回到教学状态
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = state.copyWith(petState: PetAnimationState.teaching);
        }
      });
    });
  }

  void _addUserMessage(String text) {
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      text: text,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, msg]);
  }

  void _addAssistantMessage(String text) {
    final msg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'assistant',
      text: text,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, msg]);
  }
}

final voiceChatControllerProvider =
    StateNotifierProvider<VoiceChatController, VoiceChatState>((ref) {
  return VoiceChatController();
});
