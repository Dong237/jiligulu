import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_text.dart';
import '../../shared/widgets/pet_animation_widget.dart';
import '../../shared/widgets/pet_status_bar.dart';

/// Mock milestone data.
class _Milestone {
  final String title;
  final String description;
  final bool achieved;

  const _Milestone({
    required this.title,
    required this.description,
    this.achieved = false,
  });
}

const _mockMilestones = [
  _Milestone(
    title: '\u7B2C\u4E00\u6B21\u5F00\u53E3',
    description: '\u5B8C\u6210\u7B2C\u4E00\u6B21\u8BED\u97F3\u7EC3\u4E60',
    achieved: true,
  ),
  _Milestone(
    title: '\u8FDE\u7EED\u4E09\u5929',
    description: '\u8FDE\u7EED\u5B66\u4E60 3 \u5929\u4E0D\u95F4\u65AD',
    achieved: true,
  ),
  _Milestone(
    title: '\u8BCD\u6C47\u8FBE\u4EBA',
    description: '\u7D2F\u8BA1\u5B66\u4F1A 50 \u4E2A\u8BCD\u7EC4',
    achieved: false,
  ),
];

/// JiJi status page — the pet tab showing growth and milestones.
class JiJiStatusPage extends StatelessWidget {
  const JiJiStatusPage({super.key});

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

              // Pet animation — large, greeting
              const PetAnimationWidget(
                state: PetAnimationState.greeting,
                size: PetAnimationSize.large,
              ),
              const SizedBox(height: AppSizes.spacingL),

              // Current stage name
              const ElderText(
                '\u86CB\u86CB\u671F',
                style: ElderTextStyle.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacingL),

              // XP progress bar
              const PetStatusBar(
                currentXP: 75,
                nextLevelXP: 200,
                stageName: '\u86CB\u86CB\u671F',
              ),
              const SizedBox(height: AppSizes.spacingXL),

              // Milestones section header
              const Align(
                alignment: Alignment.centerLeft,
                child: ElderText(
                  '\u91CC\u7A0B\u7891',
                  style: ElderTextStyle.subtitle,
                ),
              ),
              const SizedBox(height: AppSizes.spacingM),

              // Milestone list
              ..._mockMilestones.map((milestone) => Padding(
                    padding:
                        const EdgeInsets.only(bottom: AppSizes.spacingM),
                    child: _MilestoneTile(milestone: milestone),
                  )),

              const SizedBox(height: AppSizes.spacingXL),

              // Family management button (placeholder)
              ElderButton(
                label: '\u5BB6\u4EBA\u7BA1\u7406',
                variant: ElderButtonVariant.subtle,
                size: ElderButtonSize.standard,
                onPressed: () {
                  // TODO: Open password dialog for child mode
                },
              ),
              const SizedBox(height: AppSizes.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single milestone row.
class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.milestone});

  final _Milestone milestone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingM),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            milestone.achieved
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: milestone.achieved
                ? AppColors.parrotGreen
                : AppColors.warmGrey,
            size: 28,
          ),
          const SizedBox(width: AppSizes.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: TextStyle(
                    fontSize: AppSizes.fontBody,
                    fontWeight: FontWeight.w600,
                    color: milestone.achieved
                        ? AppColors.darkText
                        : AppColors.warmGrey,
                  ),
                ),
                const SizedBox(height: AppSizes.spacingXS),
                Text(
                  milestone.description,
                  style: const TextStyle(
                    fontSize: AppSizes.fontCaption,
                    color: AppColors.warmGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
