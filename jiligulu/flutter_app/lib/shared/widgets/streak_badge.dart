import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Badge showing consecutive learning streak days.
///
/// Hidden when [days] is 0.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    if (days == 0) return const SizedBox.shrink();

    final firePrefix = days >= 3 ? '\u{1F525} ' : '';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingM,
        vertical: AppSizes.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
      ),
      child: Text(
        '$firePrefix\u8FDE\u7EED\u5B66\u4E60 $days \u5929',
        style: const TextStyle(
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.w600,
          color: AppColors.warmOrange,
        ),
      ),
    );
  }
}
