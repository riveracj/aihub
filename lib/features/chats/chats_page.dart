import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../models/ai_spec.dart';
import '../../models/conversation.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final aiHubsAsync = ref.watch(aiHubsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[900],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            onPressed: () => context.go('/discover'),
          ),
        ],
      ),
      body: Column(
        children: [
          _TrendingAIHubRow(aiHubsAsync: aiHubsAsync),
          Expanded(
            child: conversationsAsync.when(
              data: (conversations) {
                if (conversations.isEmpty) {
                  return _EmptyChats(aiHubsAsync: aiHubsAsync);
                }

                final sorted = List<Conversation>.from(conversations)
                  ..sort((a, b) {
                    if (a.pinned && !b.pinned) return -1;
                    if (!a.pinned && b.pinned) return 1;
                    return b.updatedAt.compareTo(a.updatedAt);
                  });

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) {
                    return _ChatListItem(
                      conversation: sorted[index],
                      isDark: isDark,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingAIHubRow extends StatelessWidget {
  final AsyncValue<List<AISpec>> aiHubsAsync;

  const _TrendingAIHubRow({required this.aiHubsAsync});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: aiHubsAsync.when(
        data: (hubs) {
          final trending = hubs.take(5).toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: trending.length,
            itemBuilder: (context, index) {
              final ai = trending[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => context.push('/ai/${ai.id}'),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          child: Icon(Icons.smart_toy,
                              color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 56,
                        child: Text(
                          ai.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _EmptyChats extends StatelessWidget {
  final AsyncValue<List<AISpec>> aiHubsAsync;

  const _EmptyChats({required this.aiHubsAsync});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline,
                size: 64, color: isDark ? Colors.grey[700] : Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Discover AI personalities and start chatting',
              style: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/discover'),
              icon: const Icon(Icons.explore),
              label: const Text('Discover AI Hubs'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatListItem extends ConsumerWidget {
  final Conversation conversation;
  final bool isDark;

  const _ChatListItem({
    required this.conversation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: ValueKey(conversation.conversationId),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.notifications_off,
            label: 'Mute',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: 'Pin',
          ),
          SlidableAction(
            onPressed: (_) {},
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: Icons.favorite,
            label: 'Favorite',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: _ConversationAvatar(
          conversation: conversation,
          size: 26,
        ),
        title: Row(
          children: [
            Text(
              conversation.aiName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            if (conversation.pinned) ...[
              const SizedBox(width: 6),
              Icon(Icons.push_pin, size: 14,
                  color: isDark ? Colors.grey[600] : Colors.grey[400]),
            ],
          ],
        ),
        subtitle: Text(
          conversation.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              conversation.timeAgo,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[600] : Colors.grey[500],
              ),
            ),
            if (conversation.unreadCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () => context.push('/ai/${conversation.hubId}'),
      ),
    );
  }
}

class _ConversationAvatar extends StatelessWidget {
  final Conversation conversation;
  final double size;

  const _ConversationAvatar({
    required this.conversation,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
            ),
          ),
          child: CircleAvatar(
            radius: size,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            child: Icon(Icons.smart_toy, size: size, color: Colors.white),
          ),
        ),
        if (conversation.online)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.successGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
