import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  static const List<String> categories = ['All', 'Creative', 'Logic', 'Support'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 56,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(selectedCategoryProvider.notifier).state = category;
                  }
                },
                  selectedColor: Colors.deepPurple.withValues(alpha: 0.15),
                backgroundColor: Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.deepPurple : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
