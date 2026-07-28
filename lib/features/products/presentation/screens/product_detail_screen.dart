import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/product_provider.dart';
import '../../data/models/product_model.dart';
import '../widgets/app_states.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int id;

  const ProductDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: productAsync.when(
        data: (product) => _ProductDetailContent(product: product),
        loading: () => const LoadingState(),
        error: (err, stack) => ErrorState(
          error: err,
          onRetry: () => ref.invalidate(productDetailProvider(id)),
        ),
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  final ProductModel product;

  const _ProductDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width >= 600;

    Widget imageWidget = AspectRatio(
      aspectRatio: isWideScreen ? 1 : 1.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: product.thumbnail,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image, 
              size: 64, 
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ),
    );

    Widget detailsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(product.category.toUpperCase()),
              padding: EdgeInsets.zero,
            ),
            Row(
              children: [
                Icon(Icons.star_rounded, color: theme.colorScheme.tertiary, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${product.rating}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        Text(
          product.title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            if (product.discountPercentage > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '%${product.discountPercentage.toStringAsFixed(0)} Sale',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Icon(
              product.stock > 0 ? Icons.check_circle_outline : Icons.highlight_off,
              color: product.stock > 0 ? theme.colorScheme.primary : theme.colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              product.stock > 0 ? '(${product.stock} in stock)' : 'Out of Stock',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: product.stock > 0 ? theme.colorScheme.primary : theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),

        Text(
          'Description',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5, color: theme.hintColor),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(Icons.favorite_border),
              iconSize: 28,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.stock > 0 ? () {} : null,
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: isWideScreen
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: imageWidget),
                const SizedBox(width: 24),
                Expanded(flex: 5, child: detailsWidget),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                const SizedBox(height: 20),
                detailsWidget,
              ],
            ),
    );
  }
}