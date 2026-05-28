import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/discover/discover_page.dart';
import '../features/chats/chats_page.dart';
import '../features/chat/chat_page.dart';
import '../features/profile/profile_page.dart';
import '../core/theme/app_theme.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/chats',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithBottomNav(
          currentLocation: state.matchedLocation,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/chats',
          builder: (context, state) => const ChatsPage(),
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => const DiscoverPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/ai/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final aiId = state.pathParameters['id']!;
        return ChatPage(aiId: aiId);
      },
    ),
  ],
);

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ScaffoldWithBottomNav({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int currentIndex;
    if (currentLocation.startsWith('/discover')) {
      currentIndex = 1;
    } else if (currentLocation.startsWith('/profile')) {
      currentIndex = 2;
    } else {
      currentIndex = 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkCard : AppColors.lightCard).withValues(alpha: 0.85),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/chats');
                    break;
                  case 1:
                    context.go('/discover');
                    break;
                  case 2:
                    context.go('/profile');
                    break;
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline,
                      color: currentIndex == 0
                          ? AppColors.primaryPurple
                          : (isDark ? Colors.grey[500] : Colors.grey[600])),
                  selectedIcon: Icon(Icons.chat_bubble,
                      color: AppColors.primaryPurple),
                  label: 'Chats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined,
                      color: currentIndex == 1
                          ? AppColors.primaryPurple
                          : (isDark ? Colors.grey[500] : Colors.grey[600])),
                  selectedIcon: Icon(Icons.explore,
                      color: AppColors.primaryPurple),
                  label: 'Discover',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline,
                      color: currentIndex == 2
                          ? AppColors.primaryPurple
                          : (isDark ? Colors.grey[500] : Colors.grey[600])),
                  selectedIcon: Icon(Icons.person,
                      color: AppColors.primaryPurple),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
