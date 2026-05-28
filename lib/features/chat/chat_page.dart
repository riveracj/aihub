import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_theme.dart';
import '../../models/ai_spec.dart';

class ChatPage extends ConsumerWidget {
  final String aiId;

  const ChatPage({super.key, required this.aiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hubsAsync = ref.watch(aiHubsProvider);

    return hubsAsync.when(
      data: (hubs) {
        final ai = hubs.where((h) => h.id == aiId).firstOrNull;
        if (ai == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('AI Hub')),
            body: const Center(child: Text('AI Hub not found')),
          );
        }
        return _ChatBody(ai: ai);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ChatBody extends StatefulWidget {
  final AISpec ai;

  const _ChatBody({required this.ai});

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _showProfile = true;

  @override
  void initState() {
    super.initState();
    _messages.add(
      _ChatMessage(text: widget.ai.welcomeMessage, isUser: false),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_showProfile) {
      setState(() => _showProfile = false);
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'This is a simulated response from ${widget.ai.name}. In production, this would connect to the AI backend.',
            isUser: false,
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            _AIAvatar(ai: widget.ai, size: 18),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.ai.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: widget.ai.online
                            ? AppColors.successGreen
                            : Colors.grey[500],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.ai.online ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.ai.online
                            ? AppColors.successGreen
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.more_vert,
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (_) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: const Text('View Profile'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: const Text('Mute Notifications'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: Icon(Icons.delete_outline,
                              color: Colors.red[400]),
                          title: Text('Delete Conversation',
                              style: TextStyle(color: Colors.red[400])),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_showProfile)
            _ProfileCard(ai: widget.ai, onStartChat: _sendMessage),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 8),
                    child: Row(
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
                            radius: 12,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _dot(color: isDark ? Colors.grey[500]! : Colors.grey[400]!),
                              const SizedBox(width: 4),
                              _dot(color: isDark ? Colors.grey[500]! : Colors.grey[400]!),
                              const SizedBox(width: 4),
                              _dot(color: isDark ? Colors.grey[500]! : Colors.grey[400]!),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!message.isUser) ...[
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? null
                                : (isDark ? AppColors.darkSurface : Colors.grey[100]),
                            gradient: message.isUser
                                ? const LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: message.isUser
                                  ? const Radius.circular(20)
                                  : const Radius.circular(4),
                              bottomRight: message.isUser
                                  ? const Radius.circular(4)
                                  : const Radius.circular(20),
                            ),
                            boxShadow: message.isUser
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: message.isUser ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      if (message.isUser) const SizedBox(width: 8),
                    ],
                  ),
                );
              },
            ),
          ),
          _ChatInputBar(
            controller: _messageController,
            aiName: widget.ai.name,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _dot({required Color color}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _AIAvatar extends StatelessWidget {
  final AISpec ai;
  final double size;

  const _AIAvatar({required this.ai, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        child: Icon(Icons.smart_toy, size: size, color: Colors.white),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AISpec ai;
  final VoidCallback onStartChat;

  const _ProfileCard({required this.ai, required this.onStartChat});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkSurface : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: Icon(Icons.smart_toy, size: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ai.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              ai.specialty,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryPurple,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ai.personality,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onStartChat,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryPurple,
                side: BorderSide(color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View Profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final String aiName;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.aiName,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_circle_outline,
                color: isDark ? Colors.grey[500] : Colors.grey[600]),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Message $aiName...',
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mic_outlined,
                color: isDark ? Colors.grey[500] : Colors.grey[600]),
          ),
          const SizedBox(width: 4),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
              ),
            ),
            child: IconButton(
              onPressed: onSend,
              icon: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({required this.text, required this.isUser});
}
