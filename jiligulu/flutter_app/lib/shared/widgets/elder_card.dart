import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Elder-friendly card with optional tap feedback and haptics.
class ElderCard extends StatefulWidget {
  const ElderCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.spacingM),
    this.elevation = AppSizes.cardElevation,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double elevation;

  @override
  State<ElderCard> createState() => _ElderCardState();
}

class _ElderCardState extends State<ElderCard> {
  bool _pressed = false;

  bool get _isTappable => widget.onTap != null;

  void _handleTapDown(TapDownDetails _) {
    if (!_isTappable) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_isTappable) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (!_isTappable) return;
    setState(() => _pressed = false);
  }

  void _handleTap() {
    if (!_isTappable) return;
    HapticFeedback.lightImpact();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        color: _pressed
            ? AppColors.creamWhite.withAlpha(230)
            : AppColors.creamWhite,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((_pressed ? 8 : 13)),
            blurRadius: widget.elevation * 4,
            offset: Offset(0, widget.elevation),
          ),
        ],
      ),
      child: Padding(
        padding: widget.padding,
        child: widget.child,
      ),
    );

    if (!_isTappable) return card;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSizes.touchTarget,
          minWidth: AppSizes.touchTarget,
        ),
        child: card,
      ),
    );
  }
}
