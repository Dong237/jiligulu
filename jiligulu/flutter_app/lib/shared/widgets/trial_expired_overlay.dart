import 'package:flutter/material.dart';
import 'pet_animation_widget.dart';
import 'elder_text.dart';
import 'elder_button.dart';
import '../../core/constants/app_colors.dart';

/// 试用到期提示 — 温暖的提示，不打断当前操作
class TrialExpiredOverlay extends StatelessWidget {
  final VoidCallback? onSubscribe;
  final VoidCallback? onDismiss;

  const TrialExpiredOverlay({
    super.key,
    this.onSubscribe,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const PetAnimationWidget(
                state: PetAnimationState.encouraging,
                size: PetAnimationSize.medium,
              ),
              const SizedBox(height: 24),
              const ElderText(
                text: '免费体验结束啦',
                style: ElderTextStyle.subtitle,
              ),
              const SizedBox(height: 8),
              const ElderText(
                text: '叽叽好喜欢和你聊天！\n让孩子帮你开通会员，咱们继续学？',
                style: ElderTextStyle.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (onSubscribe != null)
                ElderButton(
                  label: '让孩子看看',
                  onPressed: onSubscribe,
                  variant: ElderButtonVariant.primary,
                ),
              const SizedBox(height: 12),
              if (onDismiss != null)
                ElderButton(
                  label: '先看看复习卡片',
                  onPressed: onDismiss,
                  variant: ElderButtonVariant.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
