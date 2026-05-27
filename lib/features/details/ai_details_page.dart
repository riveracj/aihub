import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/app_providers.dart';

class AIDetailsPage extends ConsumerWidget {
  final String aiId;

  const AIDetailsPage({super.key, required this.aiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubsAsync = ref.watch(aiHubsProvider);

    return hubsAsync.when(
      data: (hubs) {
        final ai = hubs.where((h) => h.id == aiId).firstOrNull;

        if (ai == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('AI Details')),
            body: const Center(child: Text('AI Hub not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(ai.name),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
                  child: Icon(Icons.smart_toy, size: 50, color: Colors.deepPurple[300]),
                ),
                const SizedBox(height: 20),
                Text(
                  ai.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ai.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(Icons.star, ai.rating.toStringAsFixed(1), 'Rating'),
                    _buildStatCard(Icons.people, ai.formattedUserCount, 'Users'),
                    _buildStatCard(Icons.category, ai.category, 'Category'),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/ai/${ai.id}/chat'),
                    icon: const Icon(Icons.chat),
                    label: const Text(
                      'Start Chat',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
