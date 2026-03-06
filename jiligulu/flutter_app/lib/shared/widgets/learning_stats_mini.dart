import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Compact horizontal stats display for the home page.
///
/// Hidden when all values are 0.
class LearningStatsMini extends StatelessWidget {
  const LearningStatsMini({
    super.key,
    required this.todaySessions,
    required this.todayPhrases,
    required this.weekSessions,
    required this.weekPhrases,
  });

  final int todaySessions;
  final int todayPhrases;
  final int weekSessions;
  final int weekPhrases;

  bool get _allZero =>
      todaySessions == 0 &&
      todayPhrases == 0 &&
      weekSessions == 0 &&
      weekPhrases == 0;

  @override
  Widget build(BuildContext context) {
    if (_allZero) return const SizedBox.shrink();

    return Text(
      '\u4ECA\u5929 $todaySessions\u6B21 $todayPhrases\u8BCD'
      ' | '
      '\u672C\u5468 $weekSessions\u6B21 $weekPhrases\u8BCD',
      style: const TextStyle(
        fontSize: AppSizes.fontCaption,
        color: AppColors.warmGrey,
      ),
      textAlign: TextAlign.center,
    );
  }
}
