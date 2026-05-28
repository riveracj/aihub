import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ai_spec.dart';
import '../../models/conversation.dart';

final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'All';
});

final selectedTabProvider = StateProvider<String>((ref) {
  return 'All';
});

final userCountProvider = StreamProvider<int>((ref) {
  return _fetchUserCount();
});

final aiHubsProvider = StreamProvider<List<AISpec>>((ref) {
  return _fetchAIHubs();
});

final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  return _fetchConversations();
});

final filteredAIHubsProvider = Provider<AsyncValue<List<AISpec>>>((ref) {
  final hubsAsync = ref.watch(aiHubsProvider);
  final category = ref.watch(selectedCategoryProvider);

  return hubsAsync.whenData((hubs) {
    if (category == 'All') return hubs;
    return hubs.where((h) => h.category == category).toList();
  });
});

final searchQueryProvider = StateProvider<String>((ref) {
  return '';
});

final searchResultsProvider = Provider<AsyncValue<List<AISpec>>>((ref) {
  final hubsAsync = ref.watch(aiHubsProvider);
  final query = ref.watch(searchQueryProvider);

  if (query.isEmpty) return hubsAsync;

  return hubsAsync.whenData((hubs) {
    final lowerQuery = query.toLowerCase();
    return hubs.where((h) =>
      h.name.toLowerCase().contains(lowerQuery) ||
      h.description.toLowerCase().contains(lowerQuery) ||
      h.category.toLowerCase().contains(lowerQuery)
    ).toList();
  });
});

Stream<int> _fetchUserCount() async* {
  yield 15400000;
}

Stream<List<AISpec>> _fetchAIHubs() async* {
  await Future.delayed(const Duration(milliseconds: 300));
  yield _mockAIHubs;
}

Stream<List<Conversation>> _fetchConversations() async* {
  await Future.delayed(const Duration(milliseconds: 300));
  yield _mockConversations;
}

const List<AISpec> _mockAIHubs = [
  AISpec(
    id: '1',
    name: 'Nova Writer',
    description: 'Creative writing expert helping you craft compelling stories, articles, and content.',
    avatarUrl: '',
    category: 'Writing',
    rating: 4.9,
    userCount: 82100,
    online: true,
    personality: 'Creative • Helpful • Fast',
    specialty: 'AI Writing Assistant',
    welcomeMessage: 'Want help creating your article?',
  ),
  AISpec(
    id: '2',
    name: 'Code Assistant',
    description: 'AI-powered code generation, debugging, and optimization for any programming language.',
    avatarUrl: '',
    category: 'Coding',
    rating: 4.8,
    userCount: 95400,
    online: true,
    personality: 'Precise • Detailed • Smart',
    specialty: 'Coding Assistant',
    welcomeMessage: 'Let\'s build something amazing!',
  ),
  AISpec(
    id: '3',
    name: 'Luna Tutor',
    description: 'Personal learning companion that adapts to your style and helps you master any subject.',
    avatarUrl: '',
    category: 'Learning',
    rating: 4.7,
    userCount: 67300,
    online: true,
    personality: 'Patient • Encouraging • Clear',
    specialty: 'AI Tutor',
    welcomeMessage: 'Ready to learn something new today?',
  ),
  AISpec(
    id: '4',
    name: 'Creative Muse',
    description: 'Unlock your creativity with art direction, design inspiration, and visual storytelling.',
    avatarUrl: '',
    category: 'Writing',
    rating: 4.9,
    userCount: 54200,
    online: false,
    personality: 'Inspiring • Imaginative • Bold',
    specialty: 'Creative Director',
    welcomeMessage: 'What shall we create today?',
  ),
  AISpec(
    id: '5',
    name: 'Tech Mentor',
    description: 'Expert guidance on software architecture, system design, and career growth in tech.',
    avatarUrl: '',
    category: 'Coding',
    rating: 4.6,
    userCount: 38900,
    online: true,
    personality: 'Wise • Practical • Supportive',
    specialty: 'Tech Mentor',
    welcomeMessage: 'What tech challenge can we solve?',
  ),
  AISpec(
    id: '6',
    name: 'Healthy Coach',
    description: 'Your personal wellness guide for nutrition, fitness, mindfulness, and healthy habits.',
    avatarUrl: '',
    category: 'Learning',
    rating: 4.5,
    userCount: 42100,
    online: false,
    personality: 'Motivating • Caring • Practical',
    specialty: 'Wellness Coach',
    welcomeMessage: 'Let\'s work on your wellness goals!',
  ),
];

final List<Conversation> _mockConversations = [
  Conversation(
    conversationId: 'conv1',
    hubId: '1',
    aiName: 'Nova Writer',
    avatarUrl: '',
    lastMessage: 'Want help creating your article?',
    updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
    online: true,
    unreadCount: 2,
    pinned: true,
  ),
  Conversation(
    conversationId: 'conv2',
    hubId: '2',
    aiName: 'Code Assistant',
    avatarUrl: '',
    lastMessage: 'I\'ve optimized your algorithm by 40%',
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    online: true,
    unreadCount: 0,
    pinned: false,
  ),
  Conversation(
    conversationId: 'conv3',
    hubId: '3',
    aiName: 'Luna Tutor',
    avatarUrl: '',
    lastMessage: 'Great progress on your math lesson!',
    updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    online: true,
    unreadCount: 1,
    pinned: false,
  ),
  Conversation(
    conversationId: 'conv4',
    hubId: '5',
    aiName: 'Tech Mentor',
    avatarUrl: '',
    lastMessage: 'Here\'s the system design overview',
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    online: true,
    unreadCount: 0,
    pinned: false,
  ),
  Conversation(
    conversationId: 'conv5',
    hubId: '4',
    aiName: 'Creative Muse',
    avatarUrl: '',
    lastMessage: 'Your gallery is ready to view',
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    online: false,
    unreadCount: 0,
    pinned: false,
  ),
];
