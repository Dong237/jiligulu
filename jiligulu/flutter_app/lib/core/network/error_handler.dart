import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 全局错误处理 — 鹦鹉拟人化提示，无红色
class ErrorHandler {
  ErrorHandler._();

  /// 显示友好错误提示（SnackBar）
  static void showError(BuildContext context, {String? message}) {
    final text = message ?? '叽叽遇到点小问题，再试试？';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.warmOrange, // 暖橙色，不用红色
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 网络错误专用提示
  static void showNetworkError(BuildContext context) {
    showError(context, message: '网络不太好，叽叽连不上了～');
  }

  /// 语音相关错误
  static void showVoiceError(BuildContext context) {
    showError(context, message: '叽叽没听清，再说一遍？');
  }
}
