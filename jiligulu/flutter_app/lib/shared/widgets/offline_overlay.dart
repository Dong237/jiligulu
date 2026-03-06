import 'package:flutter/material.dart';
import 'pet_animation_widget.dart';
import 'elder_text.dart';
import 'elder_button.dart';
import '../../core/constants/app_colors.dart';

/// 离线状态覆盖层 — 鹦鹉睡觉 + 复习入口
class OfflineOverlay extends StatelessWidget {
  final VoidCallback? onViewReviewCards;
  final VoidCallback? onRetry;

  const OfflineOverlay({
    super.key,
    this.onViewReviewCards,
    this.onRetry,
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
                state: PetAnimationState.sleeping,
                size: PetAnimationSize.medium,
              ),
              const SizedBox(height: 24),
              const ElderText(
                text: '叽叽休息了',
                style: ElderTextStyle.subtitle,
              ),
              const SizedBox(height: 8),
              const ElderText(
                text: '网络不太好，等会儿再试试～\n先看看复习卡片吧！',
                style: ElderTextStyle.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (onViewReviewCards != null)
                ElderButton(
                  label: '看复习卡片',
                  onPressed: onViewReviewCards,
                  variant: ElderButtonVariant.primary,
                ),
              const SizedBox(height: 12),
              if (onRetry != null)
                ElderButton(
                  label: '重新连接',
                  onPressed: onRetry,
                  variant: ElderButtonVariant.outline,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
