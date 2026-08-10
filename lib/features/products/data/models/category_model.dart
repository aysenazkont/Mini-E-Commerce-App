class CategoryModel {
  final String slug;
  final String name;

  CategoryModel({
    required this.slug,
    required this.name,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CategoryModel(
        slug: json['slug'] as String? ?? '',
        name: json['name'] as String? ?? '',
      );
    }
    if (json is String) {
      return CategoryModel(
        slug: json,
        name: json,
      );
    }
    return CategoryModel(slug: '', name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
    };
  }
}