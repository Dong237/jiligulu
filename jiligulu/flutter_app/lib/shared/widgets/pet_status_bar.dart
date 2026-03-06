import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// XP progress bar with stage name.
class PetStatusBar extends StatelessWidget {
  const PetStatusBar({
    super.key,
    required this.currentXP,
    required this.nextLevelXP,
    required this.stageName,
    this.xpGained,
  });

  final int currentXP;
  final int nextLevelXP;
  final String stageName;
  final int? xpGained;

  @override
  Widget build(BuildContext context) {
    final double progress =
        nextLevelXP > 0 ? (currentXP / nextLevelXP).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          child: SizedBox(
            height: 12,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.softBackground,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.parrotGreen),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spacingS),

        // Stage name and XP gained
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\u5F53\u524D\u9636\u6BB5\uFF1A$stageName',
              style: const TextStyle(
                fontSize: AppSizes.fontCaption,
                color: AppColors.darkText,
              ),
            ),
            if (xpGained != null)
              Text(
                '+$xpGained XP',
                style: const TextStyle(
                  fontSize: AppSizes.fontCaption,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmOrange,
                ),
              ),
          ],
        ),
        Text(
          '$currentXP / $nextLevelXP XP',
          style: const TextStyle(
            fontSize: AppSizes.fontCaption,
            color: AppColors.warmGrey,
          ),
        ),
      ],
    );
  }
}
