import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Mini E-Commerce App - Coming Soon')),
        ),
      ),
    ],
  );
}