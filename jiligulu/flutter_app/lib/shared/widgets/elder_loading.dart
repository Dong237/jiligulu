import 'package:flutter/material.dart';
import 'pet_animation_widget.dart';
import 'elder_text.dart';

/// 适老化加载状态 — 用鹦鹉思考动画替代spinner
class ElderLoading extends StatelessWidget {
  final String message;

  const ElderLoading({
    super.key,
    this.message = '叽叽在想...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PetAnimationWidget(
            state: PetAnimationState.thinking,
            size: PetAnimationSize.small,
          ),
          const SizedBox(height: 12),
          ElderText(
            text: message,
            style: ElderTextStyle.caption,
          ),
        ],
      ),
    );
  }
}
