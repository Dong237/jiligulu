import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/elder_text.dart';
import '../core/constants/app_colors.dart';
import 'elder_shell.dart';

/// App router configuration.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ElderShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) =>
                  const _PlaceholderPage(title: '首页'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/scenes',
              builder: (context, state) =>
                  const _PlaceholderPage(title: '场景'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/jiji',
              builder: (context, state) =>
                  const _PlaceholderPage(title: '叽叽'),
            ),
          ]),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/voice-chat',
        builder: (context, state) =>
            const _PlaceholderPage(title: '语音对话'),
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) =>
            const _PlaceholderPage(title: '学习总结'),
      ),
      GoRoute(
        path: '/review-cards',
        builder: (context, state) =>
            const _PlaceholderPage(title: '复习卡片'),
      ),

      // Child mode routes
      GoRoute(
        path: '/child/dashboard',
        builder: (context, state) =>
            const _PlaceholderPage(title: '家人管理'),
      ),
      GoRoute(
        path: '/child/setup',
        builder: (context, state) =>
            const _PlaceholderPage(title: '帮爸妈设置'),
      ),
      GoRoute(
        path: '/child/report',
        builder: (context, state) =>
            const _PlaceholderPage(title: '学习报告'),
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>
            const _PlaceholderPage(title: '欢迎来到叽里咕噜'),
      ),
    ],
  );
});

/// Placeholder page used during early development.
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      body: Center(
        child: ElderText(title, style: ElderTextStyle.title),
      ),
    );
  }
}
