import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum PetAnimationState {
  sleeping,
  greeting,
  teaching,
  happy,
  encouraging,
  thinking,
  farewell,
}

enum PetAnimationSize {
  large,  // 首页 — 200dp
  medium, // 对话页 — 120dp
  small,  // 复习卡片 — 48dp
}

/// 叽叽鹦鹉动画组件
///
/// 当前为 placeholder（圆形+emoji），后续替换为 Rive 动画
// TODO: Replace with Rive animation when asset is ready
class PetAnimationWidget extends StatefulWidget {
  final PetAnimationState state;
  final int growthStage;
  final PetAnimationSize size;

  const PetAnimationWidget({
    super.key,
    required this.state,
    this.growthStage = 1,
    this.size = PetAnimationSize.large,
  });

  @override
  State<PetAnimationWidget> createState() => _PetAnimationWidgetState();
}

class _PetAnimationWidgetState extends State<PetAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(PetAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    switch (widget.state) {
      case PetAnimationState.greeting:
      case PetAnimationState.happy:
      case PetAnimationState.encouraging:
        _bounceController.repeat(reverse: true);
      case PetAnimationState.thinking:
        _bounceController.repeat(
          reverse: true,
          period: const Duration(milliseconds: 1200),
        );
      default:
        _bounceController.stop();
        _bounceController.reset();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  double get _diameter {
    return switch (widget.size) {
      PetAnimationSize.large => 200,
      PetAnimationSize.medium => 120,
      PetAnimationSize.small => 48,
    };
  }

  String get _emoji {
    return switch (widget.state) {
      PetAnimationState.sleeping => '😴',
      PetAnimationState.greeting => '🦜',
      PetAnimationState.teaching => '📚',
      PetAnimationState.happy => '🎉',
      PetAnimationState.encouraging => '💪',
      PetAnimationState.thinking => '🤔',
      PetAnimationState.farewell => '👋',
    };
  }

  double get _emojiFontSize {
    return switch (widget.size) {
      PetAnimationSize.large => 80,
      PetAnimationSize.medium => 48,
      PetAnimationSize.small => 24,
    };
  }

  Color get _bgColor {
    return switch (widget.state) {
      PetAnimationState.sleeping => AppColors.parrotGreen.withValues(alpha: 0.3),
      PetAnimationState.happy => AppColors.warmOrange.withValues(alpha: 0.3),
      PetAnimationState.encouraging => AppColors.warmOrange.withValues(alpha: 0.2),
      _ => AppColors.parrotGreen.withValues(alpha: 0.2),
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: child,
        );
      },
      child: Container(
        width: _diameter,
        height: _diameter,
        decoration: BoxDecoration(
          color: _bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _emoji,
            style: TextStyle(fontSize: _emojiFontSize),
          ),
        ),
      ),
    );
  }
}
