import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {

  return ProductRepository(ApiClient());
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchCategories();
});

final filteredProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);

  if (query.trim().isNotEmpty) {
    return repository.searchProducts(query.trim());
  }

  if (category != null && category.isNotEmpty) {
    return repository.fetchProductsByCategory(category);
  }

  return repository.fetchProducts();
});

final productDetailProvider = FutureProvider.family<ProductModel, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProductDetail(id);
});