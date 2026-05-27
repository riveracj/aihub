import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';

class HubHeader extends ConsumerWidget {
  const HubHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCountAsync = ref.watch(userCountProvider);

    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 16, 20, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFF1A237E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'AI Hub Community',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              userCountAsync.when(
                data: (count) => Text(
                  '${_formatCount(count)} active users',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                loading: () => const Text(
                  'Loading...',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                error: (_, __) => const Text(
                  'Connect with the community',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
