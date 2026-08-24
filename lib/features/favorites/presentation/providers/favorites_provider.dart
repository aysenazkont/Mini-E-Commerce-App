import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/data/models/product_model.dart';
import '../../data/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository();
});

class FavoritesNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() async {
    final repository = ref.watch(favoritesRepositoryProvider);
    return repository.getFavorites();
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final currentFavorites = state.value ?? [];
    final isAlreadyFav = currentFavorites.any((item) => item.id == product.id);

    if (isAlreadyFav) {
      await repository.removeFavorite(product.id);
    } else {
      await repository.addFavorite(product);
    }

    state = AsyncValue.data(await repository.getFavorites());
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<ProductModel>>(() {
  return FavoritesNotifier();
});

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  final favorites = ref.watch(favoritesProvider).value ?? [];
  return favorites.any((product) => product.id == productId);
});