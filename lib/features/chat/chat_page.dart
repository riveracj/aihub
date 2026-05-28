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
            _AIAvatar(ai: widget.ai, size: 20),
            const SizedBox(width: 12),
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
                Text(
                  widget.ai.online ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.ai.online ? AppColors.successGreen : Colors.grey[500],
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (widget.ai.personality.isNotEmpty)
              Text(
                widget.ai.personality,
                style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[500] : Colors.grey[600]),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _TypingIndicator(isDark: isDark);
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
                        _AIAvatar(ai: widget.ai, size: 14),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: _MessageBubble(
                          message: message,
                          isDark: isDark,
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        child: Icon(Icons.smart_toy, size: size, color: Colors.white),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final bool isDark;

  const _MessageBubble({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryPurple, AppColors.secondaryBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 15,
          height: 1.4,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final bool isDark;

  const _TypingIndicator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(isDark: isDark),
                const SizedBox(width: 4),
                _dot(isDark: isDark),
                const SizedBox(width: 4),
                _dot(isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required bool isDark}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[500] : Colors.grey[400],
        shape: BoxShape.circle,
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
          const SizedBox(width: 4),
          IconButton(
            onPressed: onSend,
            icon: Icon(Icons.send_rounded, color: AppColors.primaryPurple),
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
