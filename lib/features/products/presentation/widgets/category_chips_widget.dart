import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category_model.dart';
import '../providers/product_provider.dart';

class CategoryChipsWidget extends ConsumerWidget {
  const CategoryChipsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final theme = Theme.of(context);

    return categoriesAsync.when(
      data: (categories) {
        final allCategories = [
          CategoryModel(slug: '', name: 'All'),
          ...categories,
        ];

        return SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = (selectedCategory == null && category.slug.isEmpty) ||
                  (selectedCategory == category.slug);

              return ChoiceChip(
                label: Text(
                  category.name[0].toUpperCase() + category.name.substring(1),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(searchQueryProvider.notifier).state = '';
                    ref.read(selectedCategoryProvider.notifier).state =
                        category.slug.isEmpty ? null : category.slug;
                  }
                },
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 44,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}