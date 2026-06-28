import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  Future<Response> getRequest(String path) async {
    try {
      return await _dio.get(path);
    } catch (e) {
      rethrow;
    }
  }
}