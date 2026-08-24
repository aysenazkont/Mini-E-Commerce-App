import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../../../products/presentation/widgets/app_states.dart';
import '../../../products/presentation/widgets/product_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const EmptyState(
              message: 'No favorite products found yet.',
              icon: Icons.favorite_border_rounded,
            );
          }

          final screenWidth = MediaQuery.of(context).size.width;
          final crossAxisCount = screenWidth >= 900
              ? 4
              : (screenWidth >= 600 ? 3 : 2);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return ProductCard(product: favorites[index]);
            },
          );
        },
        loading: () => const LoadingState(),
        error: (err, stack) => ErrorState(
          error: err,
          onRetry: () => ref.invalidate(favoritesProvider),
        ),
      ),
    );
  }
}