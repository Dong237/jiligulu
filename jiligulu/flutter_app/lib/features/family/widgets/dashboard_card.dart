import 'package:flutter/material.dart';
import '../../../shared/widgets/elder_card.dart';
import '../../../shared/widgets/elder_text.dart';

/// Card showing a parent's weekly learning overview.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.weekSessions,
    required this.weekMinutes,
    required this.weekPhrases,
    required this.streakDays,
    required this.petStageName,
  });

  final int weekSessions;
  final int weekMinutes;
  final int weekPhrases;
  final int streakDays;
  final String petStageName;

  @override
  Widget build(BuildContext context) {
    return ElderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ElderText(
            '妈妈本周学习概览',
            style: ElderTextStyle.subtitle,
          ),
          const SizedBox(height: 16),
          ElderText('聊了 $weekSessions 次'),
          const SizedBox(height: 8),
          ElderText('学了 $weekMinutes 分钟'),
          const SizedBox(height: 8),
          ElderText('$weekPhrases 个新词'),
          const SizedBox(height: 8),
          ElderText('连续 $streakDays 天'),
          const SizedBox(height: 16),
          ElderText(
            '叽叽现在是：$petStageName',
            style: ElderTextStyle.caption,
          ),
        ],
      ),
    );
  }
}
