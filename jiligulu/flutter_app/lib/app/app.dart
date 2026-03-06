import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

/// Root application widget for 叽里咕噜.
class JiLiGuLuApp extends ConsumerWidget {
  const JiLiGuLuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '叽里咕噜',
      theme: ElderTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
