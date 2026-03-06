import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Visual variant for [ElderButton].
enum ElderButtonVariant {
  /// ParrotGreen background, white text, 64dp height.
  primary,

  /// WarmOrange background, white text, 64dp height.
  secondary,

  /// Transparent background, parrotGreen border, 48dp height.
  outline,

  /// Transparent background, warmGrey border, 48dp height.
  subtle,
}

/// Size presets for [ElderButton].
enum ElderButtonSize {
  /// Full-size action button — 64dp height.
  core,

  /// Smaller utility button — 48dp height.
  standard,
}

/// Elder-friendly button with debounce, haptics, and press animation.
class ElderButton extends StatefulWidget {
  const ElderButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ElderButtonVariant.primary,
    this.size = ElderButtonSize.core,
    this.fullWidth = true,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ElderButtonVariant variant;
  final ElderButtonSize size;
  final bool fullWidth;
  final IconData? icon;
  final bool loading;

  @override
  State<ElderButton> createState() => _ElderButtonState();
}

class _ElderButtonState extends State<ElderButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  Timer? _debounceTimer;
  bool _debouncing = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (!_enabled) return;
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  void _handleTap() {
    if (!_enabled || _debouncing) return;

    HapticFeedback.mediumImpact();
    widget.onPressed!();

    // 300ms debounce to prevent double-tap
    _debouncing = true;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _debouncing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = _resolveHeight();
    final Color bgColor = _resolveBackground();
    final Color fgColor = _resolveForeground();
    final BorderSide? border = _resolveBorder();

    Widget child;
    if (widget.loading) {
      child = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    } else {
      final textWidget = Text(
        widget.label,
        style: TextStyle(
          fontSize: AppSizes.fontBody, // 22sp
          fontWeight: FontWeight.w600,
          color: fgColor,
        ),
      );
      if (widget.icon != null) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: fgColor, size: 24),
            const SizedBox(width: AppSizes.spacingS),
            textWidget,
          ],
        );
      } else {
        child = textWidget;
      }
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedOpacity(
          opacity: _enabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 150),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height < AppSizes.touchTarget
                  ? AppSizes.touchTarget
                  : height,
              minWidth: AppSizes.touchTarget,
            ),
            child: Container(
              height: height,
              width: widget.fullWidth ? double.infinity : null,
              padding: widget.fullWidth
                  ? null
                  : const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacingL,
                    ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadius),
                border: border != null
                    ? Border.fromBorderSide(border)
                    : null,
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  double _resolveHeight() {
    switch (widget.variant) {
      case ElderButtonVariant.primary:
      case ElderButtonVariant.secondary:
        return widget.size == ElderButtonSize.core
            ? AppSizes.buttonHeight
            : AppSizes.buttonHeightSmall;
      case ElderButtonVariant.outline:
      case ElderButtonVariant.subtle:
        return AppSizes.buttonHeightSmall;
    }
  }

  Color _resolveBackground() {
    switch (widget.variant) {
      case ElderButtonVariant.primary:
        return AppColors.parrotGreen;
      case ElderButtonVariant.secondary:
        return AppColors.warmOrange;
      case ElderButtonVariant.outline:
      case ElderButtonVariant.subtle:
        return Colors.transparent;
    }
  }

  Color _resolveForeground() {
    switch (widget.variant) {
      case ElderButtonVariant.primary:
      case ElderButtonVariant.secondary:
        return AppColors.white;
      case ElderButtonVariant.outline:
        return AppColors.parrotGreen;
      case ElderButtonVariant.subtle:
        return AppColors.warmGrey;
    }
  }

  BorderSide? _resolveBorder() {
    switch (widget.variant) {
      case ElderButtonVariant.primary:
      case ElderButtonVariant.secondary:
        return null;
      case ElderButtonVariant.outline:
        return const BorderSide(color: AppColors.parrotGreen, width: 1.5);
      case ElderButtonVariant.subtle:
        return const BorderSide(color: AppColors.warmGrey, width: 1);
    }
  }
}
