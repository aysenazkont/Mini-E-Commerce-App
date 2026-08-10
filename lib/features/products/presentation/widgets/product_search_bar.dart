import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';

class ProductSearchBar extends ConsumerStatefulWidget {
  const ProductSearchBar({super.key});

  @override
  ConsumerState<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends ConsumerState<ProductSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchQuery = ref.watch(searchQueryProvider);

    if (_controller.text != searchQuery && searchQuery.isEmpty) {
      _controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          hintText: 'Search a product or brand...',
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.outline),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}