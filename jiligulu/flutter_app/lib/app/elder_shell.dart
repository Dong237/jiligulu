import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/elder_bottom_nav.dart';

/// Shell widget that wraps tabbed pages with [ElderBottomNav].
///
/// Uses GoRouter's [StatefulNavigationShell] to preserve state
/// across tab switches.
class ElderShell extends StatelessWidget {
  const ElderShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ElderBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
