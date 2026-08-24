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
        final validCategories = categories.where((c) => c.name.trim().isNotEmpty).toList();
        final allCategories = [
          CategoryModel(slug: '', name: 'All'),
          ...validCategories,
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

              final displayName = category.name.isNotEmpty
              ? '${category.name[0].toUpperCase()}${category.name.substring(1)}'
              : '';

    return ChoiceChip(
      label: Text(displayName),
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
     error: (err, stack) => SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
              const SizedBox(width: 6),
              Text(
                'Categories could not be loaded.',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Try Again',
                onPressed: () => ref.invalidate(categoriesProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}