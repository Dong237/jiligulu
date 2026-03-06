import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

enum TalkButtonState { idle, recording, processing }

class TalkButton extends StatefulWidget {
  final TalkButtonState state;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;

  const TalkButton({
    super.key,
    required this.state,
    required this.onPressStart,
    required this.onPressEnd,
  });

  @override
  State<TalkButton> createState() => _TalkButtonState();
}

class _TalkButtonState extends State<TalkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.state == TalkButtonState.idle) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TalkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state == TalkButtonState.idle) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    return switch (widget.state) {
      TalkButtonState.idle => AppColors.warmOrange,
      TalkButtonState.recording => const Color(0xFFE8941F), // deeper orange
      TalkButtonState.processing => AppColors.warmGrey,
    };
  }

  String get _label {
    return switch (widget.state) {
      TalkButtonState.idle => '按住说话',
      TalkButtonState.recording => '正在听...',
      TalkButtonState.processing => '叽叽在想...',
    };
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.state != TalkButtonState.processing;

    return GestureDetector(
      onTapDown: enabled
          ? (_) {
              setState(() => _isPressed = true);
              HapticFeedback.mediumImpact();
              widget.onPressStart();
            }
          : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressEnd();
            }
          : null,
      onTapCancel: enabled
          ? () {
              setState(() => _isPressed = false);
              widget.onPressEnd();
            }
          : null,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale = widget.state == TalkButtonState.idle
              ? _pulseAnimation.value
              : (_isPressed ? 0.96 : 1.0);
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.state == TalkButtonState.recording
                ? [
                    BoxShadow(
                      color: AppColors.warmOrange.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              _label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
