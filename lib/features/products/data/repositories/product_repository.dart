import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);
  
 Future<List<ProductModel>> fetchProducts() async {
  
  final response = await _apiClient.getRequest('/products');
  final productsResponse = ProductsResponse.fromJson(response.data as Map<String, dynamic>);

  return productsResponse.products;
 }
}