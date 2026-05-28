class Conversation {
  final String conversationId;
  final String hubId;
  final String aiName;
  final String avatarUrl;
  final String lastMessage;
  final DateTime updatedAt;
  final bool online;
  final int unreadCount;
  final bool pinned;

  const Conversation({
    required this.conversationId,
    required this.hubId,
    required this.aiName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.updatedAt,
    this.online = true,
    this.unreadCount = 0,
    this.pinned = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'] as String? ?? '',
      hubId: json['hubId'] as String? ?? '',
      aiName: json['aiName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      updatedAt: (json['updatedAt'] as dynamic) is String
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      online: json['online'] as bool? ?? true,
      unreadCount: json['unreadCount'] as int? ?? 0,
      pinned: json['pinned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'hubId': hubId,
      'aiName': aiName,
      'avatarUrl': avatarUrl,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.toIso8601String(),
      'online': online,
      'unreadCount': unreadCount,
      'pinned': pinned,
    };
  }

  String get timeAgo {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }
}
