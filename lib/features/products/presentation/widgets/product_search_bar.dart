import 'dart:async';
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
  Timer? _debounceTimer; 

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(searchQueryProvider),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.trim().isNotEmpty && ref.read(selectedCategoryProvider) != null) {
      ref.read(selectedCategoryProvider.notifier).state = null;
    }

    _debounceTimer?.cancel();

    if (value.isEmpty) {
      ref.read(searchQueryProvider.notifier).state = '';
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  void _clearSearch() {
    _debounceTimer?.cancel();
    _controller.clear();
    ref.read(searchQueryProvider.notifier).state = '';
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
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for a product or brand...',
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.outline),
          suffixIcon: _controller.text.isNotEmpty || searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
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