import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

class CartNotifier extends AsyncNotifier<List<CartItemModel>> {
  @override
  Future<List<CartItemModel>> build() async {
    final repository = ref.watch(cartRepositoryProvider);
    return repository.getCart();
  }

  Future<void> addToCart(ProductModel product) async {
    final repository = ref.read(cartRepositoryProvider);
    final currentList = state.value ?? [];
    final existingIndex = currentList.indexWhere((item) => item.product.id == product.id);

    List<CartItemModel> updatedList;
    if (existingIndex != -1) {
      final currentItem = currentList[existingIndex];
      updatedList = [...currentList];
      updatedList[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
    } else {
      updatedList = [...currentList, CartItemModel(product: product, quantity: 1)];
    }

    await repository.saveCart(updatedList);
    state = AsyncValue.data(updatedList);
  }

  Future<void> increaseQuantity(int productId) async {
    final repository = ref.read(cartRepositoryProvider);
    final currentList = state.value ?? [];
    final updatedList = currentList.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    await repository.saveCart(updatedList);
    state = AsyncValue.data(updatedList);
  }

  Future<void> decreaseQuantity(int productId) async {
    final currentList = state.value ?? [];
    final existingItem = currentList.firstWhere((item) => item.product.id == productId);

    if (existingItem.quantity > 1) {
      final repository = ref.read(cartRepositoryProvider);
      final updatedList = currentList.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      await repository.saveCart(updatedList);
      state = AsyncValue.data(updatedList);
    } else {
      await removeFromCart(productId);
    }
  }

  Future<void> removeFromCart(int productId) async {
    final repository = ref.read(cartRepositoryProvider);
    final currentList = state.value ?? [];
    final updatedList = currentList.where((item) => item.product.id != productId).toList();

    await repository.saveCart(updatedList);
    state = AsyncValue.data(updatedList);
  }

  Future<void> clearCart() async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.clearCart();
    state = const AsyncValue.data([]);
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItemModel>>(() {
  return CartNotifier();
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider).value ?? [];
  return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider).value ?? [];
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});