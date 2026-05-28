import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ai_spec.dart';
import '../../models/conversation.dart';

final selectedCategoryProvider = StateProvider<String>((ref) {
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
    category: 'Creative',
    rating: 4.9,
    userCount: 82100,
    online: true,
    personality: 'Warm • Helpful • Fast',
    specialty: 'Creative Writing Expert',
    welcomeMessage: 'Want help creating your article?',
  ),
  AISpec(
    id: '2',
    name: 'LogicMaster',
    description: 'Solve complex problems with logical reasoning and mathematical precision.',
    avatarUrl: '',
    category: 'Logic',
    rating: 4.8,
    userCount: 54300,
    online: true,
    personality: 'Precise • Analytical • Clear',
    specialty: 'Problem Solving',
    welcomeMessage: 'Ready to solve some problems?',
  ),
  AISpec(
    id: '3',
    name: 'SupportBot',
    description: '24/7 intelligent customer support with natural language understanding.',
    avatarUrl: '',
    category: 'Support',
    rating: 4.7,
    userCount: 120500,
    online: false,
    personality: 'Patient • Friendly • Efficient',
    specialty: 'Customer Support',
    welcomeMessage: 'How can I help you today?',
  ),
  AISpec(
    id: '4',
    name: 'CodeWizard',
    description: 'AI-powered code generation, debugging, and optimization assistant.',
    avatarUrl: '',
    category: 'Logic',
    rating: 4.9,
    userCount: 95000,
    online: true,
    personality: 'Smart • Detailed • Fast',
    specialty: 'Code Assistant',
    welcomeMessage: 'Let\'s build something amazing!',
  ),
  AISpec(
    id: '5',
    name: 'ArtVisions',
    description: 'Transform ideas into breathtaking visual artwork instantly.',
    avatarUrl: '',
    category: 'Creative',
    rating: 4.6,
    userCount: 67800,
    online: true,
    personality: 'Creative • Inspiring • Visual',
    specialty: 'Art Generation',
    welcomeMessage: 'What shall we create today?',
  ),
  AISpec(
    id: '6',
    name: 'HelpDesk AI',
    description: 'Automated ticket resolution with intelligent escalation pathways.',
    avatarUrl: '',
    category: 'Support',
    rating: 4.5,
    userCount: 31200,
    online: false,
    personality: 'Professional • Quick • Reliable',
    specialty: 'IT Support',
    welcomeMessage: 'Describe your issue and I\'ll help resolve it.',
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
    hubId: '4',
    aiName: 'CodeWizard',
    avatarUrl: '',
    lastMessage: 'I\'ve optimized your algorithm by 40%',
    updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    online: true,
    unreadCount: 0,
    pinned: false,
  ),
  Conversation(
    conversationId: 'conv3',
    hubId: '5',
    aiName: 'ArtVisions',
    avatarUrl: '',
    lastMessage: 'Your gallery is ready to view',
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    online: true,
    unreadCount: 0,
    pinned: false,
  ),
  Conversation(
    conversationId: 'conv4',
    hubId: '2',
    aiName: 'LogicMaster',
    avatarUrl: '',
    lastMessage: 'The solution is 42 — just kidding!',
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    online: true,
    unreadCount: 0,
    pinned: false,
  ),
];
