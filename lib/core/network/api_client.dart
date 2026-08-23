import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

Future<Response> getRequest(
  String path, {
  Map<String, dynamic>? queryParameters,
}) async {
  return await _dio.get(path, queryParameters: queryParameters);
}}