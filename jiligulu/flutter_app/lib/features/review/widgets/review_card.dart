import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/elder_button.dart';
import '../../../shared/widgets/elder_card.dart';
import '../../../shared/widgets/elder_text.dart';
import '../../voice_chat/widgets/phrase_highlight.dart';

/// Data model for a review phrase.
class PhraseData {
  final String english;
  final String? phoneticIPA;
  final String? phoneticChinese;
  final String? chinese;

  const PhraseData({
    required this.english,
    this.phoneticIPA,
    this.phoneticChinese,
    this.chinese,
  });
}

/// Swipeable review card showing a learned phrase.
class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.phrase,
    required this.sceneName,
    required this.learnedDate,
    this.onPlayAudio,
  });

  final PhraseData phrase;
  final String sceneName;
  final String learnedDate;
  final VoidCallback? onPlayAudio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingL,
        vertical: AppSizes.spacingM,
      ),
      child: ElderCard(
        padding: const EdgeInsets.all(AppSizes.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full phrase highlight
            PhraseHighlight(
              english: phrase.english,
              phoneticIPA: phrase.phoneticIPA,
              phoneticChinese: phrase.phoneticChinese,
              chinese: phrase.chinese,
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Scene name and date
            Text(
              '$sceneName \u00B7 $learnedDate',
              style: const TextStyle(
                fontSize: AppSizes.fontCaption,
                color: AppColors.warmGrey,
              ),
            ),
            const SizedBox(height: AppSizes.spacingL),

            // Play audio button
            ElderButton(
              label: '\u70B9\u51FB\u542C\u53D1\u97F3',
              variant: ElderButtonVariant.outline,
              size: ElderButtonSize.standard,
              icon: Icons.volume_up_rounded,
              onPressed: onPlayAudio ?? () {},
            ),
          ],
        ),
      ),
    );
  }
}
