import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ai_spec.dart';

final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'All';
});

final userCountProvider = StreamProvider<int>((ref) {
  return _fetchUserCount();
});

final filteredCategoryProvider = Provider<String>((ref) {
  return ref.watch(selectedCategoryProvider);
});

final aiHubsProvider = StreamProvider<List<AISpec>>((ref) {
  return _fetchAIHubs();
});

final filteredAIHubsProvider = Provider<AsyncValue<List<AISpec>>>((ref) {
  final hubsAsync = ref.watch(aiHubsProvider);
  final category = ref.watch(selectedCategoryProvider);

  return hubsAsync.whenData((hubs) {
    if (category == 'All') return hubs;
    return hubs.where((h) => h.category == category).toList();
  });
});

Stream<int> _fetchUserCount() async* {
  yield 15400000;
}

Stream<List<AISpec>> _fetchAIHubs() async* {
  await Future.delayed(const Duration(milliseconds: 500));
  yield _mockAIHubs;
}

const List<AISpec> _mockAIHubs = [
  AISpec(
    id: '1',
    name: 'CreativeAI',
    description: 'Generate stunning art, designs, and creative content with advanced neural networks.',
    avatarUrl: '',
    category: 'Creative',
    rating: 4.9,
    userCount: 82100,
  ),
  AISpec(
    id: '2',
    name: 'LogicMaster',
    description: 'Solve complex problems with logical reasoning and mathematical precision.',
    avatarUrl: '',
    category: 'Logic',
    rating: 4.8,
    userCount: 54300,
  ),
  AISpec(
    id: '3',
    name: 'SupportBot',
    description: '24/7 intelligent customer support with natural language understanding.',
    avatarUrl: '',
    category: 'Support',
    rating: 4.7,
    userCount: 120500,
  ),
  AISpec(
    id: '4',
    name: 'CodeWizard',
    description: 'AI-powered code generation, debugging, and optimization assistant.',
    avatarUrl: '',
    category: 'Logic',
    rating: 4.9,
    userCount: 95000,
  ),
  AISpec(
    id: '5',
    name: 'ArtVisions',
    description: 'Transform ideas into breathtaking visual artwork instantly.',
    avatarUrl: '',
    category: 'Creative',
    rating: 4.6,
    userCount: 67800,
  ),
  AISpec(
    id: '6',
    name: 'HelpDesk AI',
    description: 'Automated ticket resolution with intelligent escalation pathways.',
    avatarUrl: '',
    category: 'Support',
    rating: 4.5,
    userCount: 31200,
  ),
];
