import 'package:flutter/material.dart';
import '../../../shared/widgets/elder_button.dart';

class QuickReplyBar extends StatelessWidget {
  final void Function(String) onSelect;
  final List<String> options;

  const QuickReplyBar({
    super.key,
    required this.onSelect,
    this.options = const ['再说一遍', '太难了', '换一个'],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: options.map((option) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElderButton(
                label: option,
                variant: ElderButtonVariant.outline,
                size: ElderButtonSize.standard,
                fullWidth: true,
                onPressed: () => onSelect(option),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
