import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsFutureProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️Product List🛍️'),
        centerTitle: true,
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products were found.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,      
              childAspectRatio: 0.7, 
              crossAxisSpacing: 12,     
              mainAxisSpacing: 12,     
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product: product); 
            },
          );
        },
        error: (err, stack) => Center(
          child: Text('An error occured: $err'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(), 
        ),
      ),
    );
  }
}