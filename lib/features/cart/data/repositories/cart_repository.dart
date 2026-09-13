import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  static const String _cartKey = 'cart_items';
  Future<List<CartItemModel>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(_cartKey) ?? [];

    return stringList
        .map((itemStr) => CartItemModel.fromJson(jsonDecode(itemStr) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, stringList);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}