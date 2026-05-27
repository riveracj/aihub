import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_page.dart';
import '../features/details/ai_details_page.dart';
import '../features/chat/chat_page.dart';
import '../features/chats/chats_page.dart';
import '../features/profile/profile_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
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
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/chats',
          builder: (context, state) => const ChatsPage(),
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
        return AIDetailsPage(aiId: aiId);
      },
      routes: [
        GoRoute(
          path: 'chat',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final aiId = state.pathParameters['id']!;
            return ChatPage(aiId: aiId);
          },
        ),
      ],
    ),
  ],
);

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    int currentIndex;
    if (currentLocation.startsWith('/chats')) {
      currentIndex = 1;
    } else if (currentLocation.startsWith('/profile')) {
      currentIndex = 2;
    } else {
      currentIndex = 0;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/chats');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
