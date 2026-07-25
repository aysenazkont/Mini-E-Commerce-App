import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_ecommerce_app/core/network/api_client.dart';
import 'package:mini_ecommerce_app/features/products/data/models/product_model.dart';
import 'package:mini_ecommerce_app/features/products/data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider); 
  return ProductRepository(apiClient);
});

final productsFutureProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProducts();
});

final productDetailProvider = FutureProvider.family<ProductModel, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProductDetail(id);
});