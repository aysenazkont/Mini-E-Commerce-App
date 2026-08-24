import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../products/data/models/product_model.dart';

class FavoritesRepository {
  static const String _favoritesKey = 'favorite_products_key';
Future<List<ProductModel>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonStringList = prefs.getStringList(_favoritesKey);

      if (jsonStringList == null || jsonStringList.isEmpty) {
        return [];
      }
      
  return jsonStringList.map((itemStr) {
        final Map<String, dynamic> jsonMap = jsonDecode(itemStr) as Map<String, dynamic>;
        return ProductModel.fromJson(jsonMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await getFavorites();

    final isAlreadyInFavorites = currentFavorites.any((item) => item.id == product.id);
    if (!isAlreadyInFavorites) {
      currentFavorites.add(product);
      await _saveFavoritesList(prefs, currentFavorites);
    }
  }

  Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = await getFavorites();

    currentFavorites.removeWhere((item) => item.id == productId);
    await _saveFavoritesList(prefs, currentFavorites);
  }

  Future<void> _saveFavoritesList(SharedPreferences prefs, List<ProductModel> products) async {
    final List<String> stringList = products.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_favoritesKey, stringList);
  }
}