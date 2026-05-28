import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AIHubApp(),
    ),
  );
}

class AIHubApp extends ConsumerWidget {
  const AIHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeValueProvider);

    return MaterialApp.router(
      title: 'AI Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
