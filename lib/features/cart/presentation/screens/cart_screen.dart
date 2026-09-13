import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../products/presentation/widgets/app_states.dart';
import '../../data/models/cart_item_model.dart';
import '../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
Widget build(BuildContext context, WidgetRef ref) {
  final cartAsync = ref.watch(cartProvider);
  final totalPrice = ref.watch(cartTotalPriceProvider);
  final isWideScreen = MediaQuery.of(context).size.width >= 700;

  return Scaffold(
    appBar: AppBar(
      title: const Text('My Cart'),
      centerTitle: true,
      actions: [
        if ((cartAsync.value ?? []).isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear Cart',
            onPressed: () => _showClearDialog(context, ref),
          ),
      ],
    ),
    body: cartAsync.when(
      data: (cartItems) {
        if (cartItems.isEmpty) {
          return const EmptyState(
            message: 'No products in your cart yet.',
            icon: Icons.shopping_cart_outlined,
          );
        }
        return isWideScreen
            ? _buildWideLayout(context, ref, cartItems, totalPrice)
            : _buildMobileLayout(context, ref, cartItems, totalPrice);
      },
      loading: () => const LoadingState(),
      error: (err, stack) => ErrorState(
        error: err,
        onRetry: () => ref.invalidate(cartProvider),
      ),
    ),
  );
}

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    List<CartItemModel> items,
    double totalPrice,
  ) {
    return Column(
      children: [
        Expanded(child: _buildCartList(items, ref)),
        _buildCheckoutSummary(context, totalPrice, isWide: false),
      ],
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    WidgetRef ref,
    List<CartItemModel> items,
    double totalPrice,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildCartList(items, ref)),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildCheckoutSummary(context, totalPrice, isWide: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(List<CartItemModel> items, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        return _CartItemTile(item: item);
      },
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, double totalPrice, {required bool isWide}) {
    final theme = Theme.of(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Price', style: theme.textTheme.titleMedium),
            Text(
              '\$${totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order completion will be added soon.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Complete Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );

    if (isWide) return content;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            offset: const Offset(0, -3),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(child: content),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('All the products in your cart will be deleted. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(ctx);
            },
            child: const Text('Yes, Clear'),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItemModel item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final product = item.product;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 70,
                height: 70,
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)} / pieces',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total: \$${item.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 22),
                  onPressed: () {
                    ref.read(cartProvider.notifier).decreaseQuantity(product.id);
                  },
                ),
                Text(
                  '${item.quantity}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  onPressed: () {
                    ref.read(cartProvider.notifier).increaseQuantity(product.id);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error, size: 22),
                  onPressed: () {
                    ref.read(cartProvider.notifier).removeFromCart(product.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}