import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
      ),
    ],
  );
}