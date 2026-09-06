import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../products/data/models/product_model.dart';
import '../../data/models/cart_item_model.dart';

class CartNotifier extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() {
    return [];
  }

  void addToCart(ProductModel product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final currentItem = state[existingIndex];
      final updatedList = [...state];
      updatedList[existingIndex] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
      state = updatedList;
    } else {
      state = [...state, CartItemModel(product: product, quantity: 1)];
    }
  }

  void increaseQuantity(int productId) {
    state = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
  }

  void decreaseQuantity(int productId) {
    final existingItem = state.firstWhere((item) => item.product.id == productId);

    if (existingItem.quantity > 1) {
      state = state.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();
    } else {
      removeFromCart(productId);
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(CartNotifier.new);

final cartTotalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});