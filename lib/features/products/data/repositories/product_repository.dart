import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);
  
  Future<List<ProductModel>> fetchProducts() async {
  try {
    final response = await _apiClient.getRequest('/products');
    final List<dynamic> productListJson = response.data['products'];
    return productListJson
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
        
  } catch (e) {
    rethrow;
  }
}
}