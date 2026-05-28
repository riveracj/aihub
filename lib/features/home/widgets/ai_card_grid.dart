import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/ai_spec.dart';

class AICardGrid extends ConsumerWidget {
  const AICardGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredHubs = searchQuery.isEmpty
        ? ref.watch(filteredAIHubsProvider)
        : ref.watch(searchResultsProvider);

    return filteredHubs.when(
      data: (hubs) {
        if (hubs.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[700]
                          : Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No AI hubs found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => AICard(ai: hubs[index]),
              childCount: hubs.length,
            ),
          ),
        );
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primaryPurple),
              const SizedBox(height: 16),
              Text(
                'Loading AI hubs...',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Failed to load AI hubs',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AICard extends StatelessWidget {
  final AISpec ai;

  const AICard({super.key, required this.ai});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shadowColor: AppColors.primaryPurple.withValues(alpha: isDark ? 0.3 : 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/ai/${ai.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildAvatar(isDark: isDark),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ai.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.grey[900],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        ai.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 15),
                        const SizedBox(width: 3),
                        Text(
                          ai.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.people,
                            color: isDark ? Colors.grey[600] : Colors.grey[500],
                            size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${ai.formattedUserCount} users',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[600] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () => context.push('/ai/${ai.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.zero,
                          elevation: 2,
                          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
                        ),
                        child: const Text(
                          'Message',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required bool isDark}) {
    if (ai.avatarUrl.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryPurple.withValues(alpha: isDark ? 0.3 : 0.1),
              AppColors.secondaryBlue.withValues(alpha: isDark ? 0.2 : 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Icon(Icons.smart_toy,
              size: 40,
              color: isDark
                  ? AppColors.primaryPurple.withValues(alpha: 0.7)
                  : AppColors.primaryPurple),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: ai.avatarUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: isDark ? AppColors.darkSurface : Colors.grey[200],
        child: Center(
          child: Icon(Icons.image,
              color: isDark ? Colors.grey[600] : Colors.grey[400], size: 30),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: isDark ? AppColors.darkSurface : Colors.grey[200],
        child: Center(
          child: Icon(Icons.broken_image,
              color: isDark ? Colors.grey[600] : Colors.grey[400], size: 30),
        ),
      ),
    );
  }
}
