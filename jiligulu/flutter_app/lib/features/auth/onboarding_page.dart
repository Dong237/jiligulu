import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_text.dart';
import '../../shared/widgets/pet_animation_widget.dart';

/// First-launch identity selection page.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Pet animation — large, greeting
              const PetAnimationWidget(
                state: PetAnimationState.greeting,
                size: PetAnimationSize.large,
              ),
              const SizedBox(height: AppSizes.spacingXL),

              // Welcome text
              const ElderText(
                '欢迎来到叽里咕噜！',
                style: ElderTextStyle.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacingM),
              const ElderText(
                '叽叽是你的英语学习小伙伴～',
                style: ElderTextStyle.body,
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Identity selection buttons
              ElderButton(
                label: '帮爸妈设置',
                variant: ElderButtonVariant.primary,
                onPressed: () => context.push('/child/setup'),
              ),
              const SizedBox(height: AppSizes.spacingM),
              ElderButton(
                label: '我是爸妈（扫码登录）',
                variant: ElderButtonVariant.outline,
                onPressed: () {
                  // TODO: Implement QR scan login in future phase
                },
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
