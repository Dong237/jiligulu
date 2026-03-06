import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_card.dart';
import '../../shared/widgets/elder_text.dart';
import '../../shared/widgets/pet_animation_widget.dart';
import '../../shared/widgets/streak_badge.dart';
import '../../shared/widgets/learning_stats_mini.dart';
import 'home_controller.dart';

/// Main home page — one big parrot, one big button.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  PetAnimationState _petState = PetAnimationState.sleeping;

  @override
  void initState() {
    super.initState();
    // Transition from sleeping to greeting after a short delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _petState = PetAnimationState.greeting);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

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

              // Pet animation — large, center
              PetAnimationWidget(
                state: _petState,
                size: PetAnimationSize.large,
              ),
              const SizedBox(height: AppSizes.spacingXL),

              // Main CTA button
              ElderButton(
                label: '\u5F00\u59CB\u804A\u5929',
                variant: ElderButtonVariant.primary,
                size: ElderButtonSize.core,
                onPressed: () => context.push('/voice-chat'),
              ),
              const SizedBox(height: AppSizes.spacingL),

              // Streak badge
              if (homeState.streakDays > 0) ...[
                StreakBadge(days: homeState.streakDays),
                const SizedBox(height: AppSizes.spacingM),
              ],

              // Learning stats
              if (homeState.hasHistory) ...[
                LearningStatsMini(
                  todaySessions: homeState.todaySessions,
                  todayPhrases: homeState.todayPhrases,
                  weekSessions: homeState.weekSessions,
                  weekPhrases: homeState.weekPhrases,
                ),
                const SizedBox(height: AppSizes.spacingL),
              ],

              // Quick access cards row
              Row(
                children: [
                  Expanded(
                    child: ElderCard(
                      onTap: () => context.push('/review-cards'),
                      child: Column(
                        children: const [
                          Icon(Icons.style_rounded,
                              color: AppColors.parrotGreen, size: 32),
                          SizedBox(height: AppSizes.spacingS),
                          ElderText(
                            '\u590D\u4E60\u5361\u7247',
                            style: ElderTextStyle.body,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingM),
                  Expanded(
                    child: ElderCard(
                      onTap: () => context.go('/scenes'),
                      child: Column(
                        children: const [
                          Icon(Icons.chat_bubble_outline_rounded,
                              color: AppColors.warmOrange, size: 32),
                          SizedBox(height: AppSizes.spacingS),
                          ElderText(
                            '\u6211\u7684\u573A\u666F',
                            style: ElderTextStyle.body,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
