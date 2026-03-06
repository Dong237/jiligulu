import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/pet_animation_widget.dart';
import '../../shared/widgets/elder_text.dart';
import '../../core/constants/app_colors.dart';
import 'widgets/talk_button.dart';
import 'widgets/subtitle_display.dart';
import 'widgets/quick_reply_bar.dart';
import 'voice_chat_controller.dart';

class VoiceChatPage extends ConsumerWidget {
  const VoiceChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceChatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        title: const ElderText('和叽叽聊天', style: ElderTextStyle.subtitle),
        centerTitle: true,
        backgroundColor: AppColors.creamWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 鹦鹉动画
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: PetAnimationWidget(
                state: state.petState,
                size: PetAnimationSize.medium,
              ),
            ),

            // 字幕区域
            Expanded(
              child: SubtitleDisplay(
                messages: state.messages,
                isStreaming: state.isStreaming,
              ),
            ),

            // 快捷回复
            if (!state.isRecording)
              QuickReplyBar(
                onSelect: (reply) {
                  ref.read(voiceChatControllerProvider.notifier)
                      .sendQuickReply(reply);
                },
              ),

            // 说话按钮
            Padding(
              padding: const EdgeInsets.all(16),
              child: TalkButton(
                state: state.talkButtonState,
                onPressStart: () {
                  ref.read(voiceChatControllerProvider.notifier).startRecording();
                },
                onPressEnd: () {
                  ref.read(voiceChatControllerProvider.notifier).stopRecording();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
