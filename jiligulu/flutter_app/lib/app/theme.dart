import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// Elder-first theme for 叽里咕噜.
///
/// All font sizes are >= 18sp. Touch targets are >= 48dp.
/// No red is used anywhere in the color scheme.
class ElderTheme {
  ElderTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.softBackground,

      // ── Color scheme (no red!) ──
      colorScheme: const ColorScheme.light(
        primary: AppColors.parrotGreen,
        onPrimary: AppColors.white,
        secondary: AppColors.warmOrange,
        onSecondary: AppColors.white,
        surface: AppColors.creamWhite,
        onSurface: AppColors.darkText,
        error: AppColors.warmOrange, // use orange instead of red
        onError: AppColors.white,
      ),

      // ── Typography — all sizes >= 18sp ──
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppSizes.fontTitle,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
          height: 1.3,
        ),
        titleLarge: TextStyle(
          fontSize: AppSizes.fontSubtitle,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          fontSize: AppSizes.fontBody,
          fontWeight: FontWeight.normal,
          color: AppColors.darkText,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: AppColors.darkText,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: AppSizes.fontCaption, // 18sp minimum!
          fontWeight: FontWeight.normal,
          color: AppColors.warmGrey,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),

      // ── Elevated button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.parrotGreen,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppSizes.fontBody,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: AppColors.creamWhite,
        elevation: AppSizes.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingS,
        ),
      ),

      // ── Bottom navigation ──
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.creamWhite,
        selectedItemColor: AppColors.parrotGreen,
        unselectedItemColor: AppColors.warmGrey,
        selectedLabelStyle: TextStyle(
          fontSize: AppSizes.fontCaption,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppSizes.fontCaption,
        ),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),

      // ── App bar ──
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.creamWhite,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppSizes.fontSubtitle,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ),

      // ── Input decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.creamWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingM,
          vertical: AppSizes.spacingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.warmGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.warmGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          borderSide: const BorderSide(color: AppColors.parrotGreen, width: 2),
        ),
        hintStyle: const TextStyle(
          fontSize: AppSizes.fontCaption,
          color: AppColors.warmGrey,
        ),
      ),
    );
  }
}
