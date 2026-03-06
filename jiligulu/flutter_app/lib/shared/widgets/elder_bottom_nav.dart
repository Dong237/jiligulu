import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Elder-friendly bottom navigation bar with 3 tabs.
///
/// Labels are always visible (18sp minimum). Active color is parrotGreen.
class ElderBottomNav extends StatelessWidget {
  const ElderBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.bottomNavHeight,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.creamWhite,
        selectedItemColor: AppColors.parrotGreen,
        unselectedItemColor: AppColors.warmGrey,
        selectedLabelStyle: const TextStyle(
          fontSize: AppSizes.fontCaption, // 18sp
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: AppSizes.fontCaption, // 18sp
        ),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: '场景',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: '叽叽',
          ),
        ],
      ),
    );
  }
}
