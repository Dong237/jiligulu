import 'package:flutter/material.dart';
import '../../../shared/widgets/elder_button.dart';

/// Placeholder share button for Phase 6 (WeChat sharing).
class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    this.label = '一键分享',
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElderButton(
      label: label,
      variant: ElderButtonVariant.secondary,
      size: ElderButtonSize.standard,
      fullWidth: false,
      onPressed: onPressed ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '分享功能即将上线～',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
    );
  }
}
