import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PhraseHighlight extends StatelessWidget {
  final String english;
  final String? phoneticIPA;
  final String? phoneticChinese; // 谐音
  final String? chinese;
  final VoidCallback? onTap;
  final bool compact;

  const PhraseHighlight({
    super.key,
    required this.english,
    this.phoneticIPA,
    this.phoneticChinese,
    this.chinese,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact();
    }
    return _buildFull();
  }

  Widget _buildFull() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.parrotGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 英文 — 大号绿色
            Text(
              english,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.parrotGreen,
              ),
            ),
            if (phoneticIPA != null) ...[
              const SizedBox(height: 4),
              Text(
                phoneticIPA!,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.warmGrey,
                ),
              ),
            ],
            if (chinese != null) ...[
              const SizedBox(height: 4),
              Text(
                chinese!,
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.darkText,
                ),
              ),
            ],
            if (phoneticChinese != null) ...[
              const SizedBox(height: 4),
              Text(
                '谐音：${phoneticChinese!}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.warmOrange,
                ),
              ),
            ],
            if (onTap != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.volume_up_rounded,
                      color: AppColors.parrotGreen, size: 22),
                  const SizedBox(width: 4),
                  const Text(
                    '点击听发音',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.parrotGreen,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompact() {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            english,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.parrotGreen,
            ),
          ),
          if (chinese != null) ...[
            const SizedBox(width: 8),
            Text(
              chinese!,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.warmGrey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
