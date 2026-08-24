import 'package:go_router/go_router.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart'; // Bir sonraki adımda oluşturacağız
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductListScreen(),
      routes: [
        GoRoute(
          path: 'product/:id',
          name: 'productDetail',
          builder: (context, state) {
            final productId = int.parse(state.pathParameters['id']!);
            return ProductDetailScreen(id: productId);
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
      ],
    ),
  ],
);