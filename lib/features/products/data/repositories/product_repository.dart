import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';
import '../models/products_response.dart';
import '../models/category_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);
  
 Future<List<ProductModel>> fetchProducts() async {
  
  final response = await _apiClient.getRequest('/products');
  final productsResponse = ProductsResponse.fromJson(response.data as Map<String, dynamic>);

  return productsResponse.products;
 }

 Future<ProductModel> fetchProductDetail(int id) async {
    final response = await _apiClient.getRequest('/products/$id');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
 }

 Future<List<ProductModel>> searchProducts(String query) async {
    final response = await _apiClient.getRequest('/products/search?q=$query');
    final productsResponse = ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    return productsResponse.products;
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _apiClient.getRequest('/products/categories');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((item) => CategoryModel.fromJson(item)).toList();
  }

  Future<List<ProductModel>> fetchProductsByCategory(String categorySlug) async {
    final response = await _apiClient.getRequest('/products/category/$categorySlug');
    final productsResponse = ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    return productsResponse.products;
  }
}