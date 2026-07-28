import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';
import '../widgets/app_states.dart'; 
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
      ),
body: productsAsync.when(
  data: (products) {
    if (products.isEmpty) {
      return const EmptyState(
        message: 'No products were found.',
        icon: Icons.search_off_rounded,
      );
    }
    return ProductGrid(products: products);
  },
  loading: () => const LoadingState(),
  error: (err, stack) => ErrorState(
    error: err,
    onRetry: () => ref.invalidate(productsFutureProvider),
  ),
),
    );
  }
}
  class ProductGrid extends StatelessWidget {
  final List<ProductModel> products; 

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    
    final int crossAxisCount = screenWidth >= 900 
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
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}