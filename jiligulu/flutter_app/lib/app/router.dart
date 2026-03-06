import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/elder_text.dart';
import '../core/constants/app_colors.dart';
import '../features/home/home_page.dart';
import '../features/scenes/scene_list_page.dart';
import '../features/pet/jiji_status_page.dart';
import '../features/voice_chat/voice_chat_page.dart';
import '../features/summary/session_summary_page.dart';
import '../features/review/review_cards_page.dart';
import '../features/family/child_dashboard_page.dart';
import '../features/family/setup_wizard_page.dart';
import '../features/auth/onboarding_page.dart';
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
                  const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/scenes',
              builder: (context, state) =>
                  const SceneListPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/jiji',
              builder: (context, state) =>
                  const JiJiStatusPage(),
            ),
          ]),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/voice-chat',
        builder: (context, state) =>
            const VoiceChatPage(),
      ),
      GoRoute(
        path: '/summary',
        builder: (context, state) =>
            const SessionSummaryPage(),
      ),
      GoRoute(
        path: '/review-cards',
        builder: (context, state) =>
            const ReviewCardsPage(),
      ),

      // Child mode routes
      GoRoute(
        path: '/child/dashboard',
        builder: (context, state) =>
            const ChildDashboardPage(),
      ),
      GoRoute(
        path: '/child/setup',
        builder: (context, state) =>
            const SetupWizardPage(),
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
            const OnboardingPage(),
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
