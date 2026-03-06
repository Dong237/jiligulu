import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_card.dart';
import '../../shared/widgets/elder_text.dart';
import '../../shared/widgets/pet_animation_widget.dart';
import '../../shared/widgets/pet_status_bar.dart';
import '../voice_chat/widgets/phrase_highlight.dart';

/// Summary shown after a voice chat session ends.
class SessionSummaryPage extends StatelessWidget {
  const SessionSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacingL,
            vertical: AppSizes.spacingL,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spacingL),

              // Pet farewell
              const PetAnimationWidget(
                state: PetAnimationState.farewell,
                size: PetAnimationSize.medium,
              ),
              const SizedBox(height: AppSizes.spacingL),

              // Encouragement text
              const ElderText(
                '\u4ECA\u5929\u5B66\u5F97\u4E0D\u9519\uFF01',
                style: ElderTextStyle.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacingXL),

              // Phrases learned card
              ElderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ElderText(
                      '\u4ECA\u5929\u5B66\u7684\u8BCD',
                      style: ElderTextStyle.subtitle,
                    ),
                    SizedBox(height: AppSizes.spacingM),
                    PhraseHighlight(
                      english: 'Good morning',
                      chinese: '\u65E9\u4E0A\u597D',
                      compact: true,
                    ),
                    SizedBox(height: AppSizes.spacingS),
                    PhraseHighlight(
                      english: 'Thank you',
                      chinese: '\u8C22\u8C22',
                      compact: true,
                    ),
                    SizedBox(height: AppSizes.spacingS),
                    PhraseHighlight(
                      english: 'See you later',
                      chinese: '\u56DE\u5934\u89C1',
                      compact: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacingL),

              // XP progress
              const PetStatusBar(
                currentXP: 75,
                nextLevelXP: 200,
                stageName: '\u86CB\u86CB\u671F',
                xpGained: 25,
              ),
              const SizedBox(height: AppSizes.spacingXL),

              // Action buttons
              ElderButton(
                label: '\u770B\u590D\u4E60\u5361\u7247',
                variant: ElderButtonVariant.primary,
                onPressed: () => context.go('/review-cards'),
              ),
              const SizedBox(height: AppSizes.spacingM),
              ElderButton(
                label: '\u56DE\u5230\u9996\u9875',
                variant: ElderButtonVariant.outline,
                onPressed: () => context.go('/'),
              ),
              const SizedBox(height: AppSizes.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
