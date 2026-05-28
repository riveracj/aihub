import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  static const List<String> categories = ['All', 'Creative', 'Logic', 'Support'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                selectedColor: AppColors.primaryPurple.withValues(alpha: isDark ? 0.25 : 0.12),
                backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[100],
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : (isDark ? AppColors.darkSurface : Colors.grey[300]!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
