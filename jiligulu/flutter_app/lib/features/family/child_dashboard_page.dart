import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/widgets/elder_button.dart';
import '../../shared/widgets/elder_card.dart';
import '../../shared/widgets/elder_text.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/share_button.dart';

/// Child dashboard showing parent's learning progress.
class ChildDashboardPage extends StatelessWidget {
  const ChildDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.softBackground,
        elevation: 0,
        title: const ElderText('家人管理', style: ElderTextStyle.subtitle),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '返回老人端',
              style: TextStyle(
                fontSize: AppSizes.fontCaption,
                color: AppColors.parrotGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spacingL),
        children: [
          // Weekly overview card
          const DashboardCard(
            weekSessions: 5,
            weekMinutes: 35,
            weekPhrases: 12,
            streakDays: 3,
            petStageName: '毛球期',
          ),
          const SizedBox(height: AppSizes.spacingL),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: ElderButton(
                  label: '详细报告',
                  variant: ElderButtonVariant.outline,
                  size: ElderButtonSize.standard,
                  onPressed: () {
                    // TODO: Navigate to /child/report in Phase 6
                  },
                ),
              ),
              const SizedBox(width: AppSizes.spacingM),
              const Expanded(
                child: ShareButton(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacingXL),

          // Recent phrases section
          const ElderText('最近学的', style: ElderTextStyle.subtitle),
          const SizedBox(height: AppSizes.spacingM),
          ..._buildRecentPhrases(),
          const SizedBox(height: AppSizes.spacingXL),

          // Settings placeholder
          ElderCard(
            child: Row(
              children: const [
                Icon(Icons.settings, color: AppColors.warmGrey, size: 28),
                SizedBox(width: AppSizes.spacingM),
                ElderText('设置', style: ElderTextStyle.body),
              ],
            ),
            onTap: () {
              // TODO: Settings page in future phase
            },
          ),
          const SizedBox(height: AppSizes.spacingL),
        ],
      ),
    );
  }

  /// Placeholder recent phrases list.
  List<Widget> _buildRecentPhrases() {
    final phrases = [
      {'en': 'Good morning', 'zh': '早上好'},
      {'en': 'Thank you', 'zh': '谢谢'},
      {'en': 'How much?', 'zh': '多少钱？'},
      {'en': 'Excuse me', 'zh': '打扰一下'},
    ];

    return phrases.map((p) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.spacingS),
        child: ElderCard(
          child: Row(
            children: [
              Expanded(
                child: ElderText(p['en']!, style: ElderTextStyle.body),
              ),
              ElderText(
                p['zh']!,
                style: ElderTextStyle.caption,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
