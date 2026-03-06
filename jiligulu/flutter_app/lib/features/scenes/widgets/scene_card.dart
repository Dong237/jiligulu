import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/elder_card.dart';

/// Card representing a single conversation scene.
class SceneCard extends StatelessWidget {
  const SceneCard({
    super.key,
    required this.name,
    required this.previewPhrases,
    required this.difficulty,
    this.isLocked = false,
    this.isCompleted = false,
    this.onTap,
  });

  final String name;
  final List<String> previewPhrases;
  final int difficulty;
  final bool isLocked;
  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElderCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.spacingM),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 80),
        child: Row(
          children: [
            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Scene name + completed checkmark
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: AppSizes.fontBody,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      if (isCompleted) ...[
                        const SizedBox(width: AppSizes.spacingS),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.parrotGreen,
                          size: 22,
                        ),
                      ],
                    ],
                  ),

                  // Preview phrase
                  if (previewPhrases.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spacingXS),
                    Text(
                      previewPhrases.first,
                      style: const TextStyle(
                        fontSize: AppSizes.fontCaption,
                        color: AppColors.warmGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Locked hint
                  if (isLocked) ...[
                    const SizedBox(height: AppSizes.spacingXS),
                    const Text(
                      '\u4F1A\u5458\u5185\u5BB9',
                      style: TextStyle(
                        fontSize: AppSizes.fontCaption,
                        color: AppColors.warmOrange,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppSizes.spacingS),

            // Difficulty stars
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    return Icon(
                      i < difficulty
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.warmOrange,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
