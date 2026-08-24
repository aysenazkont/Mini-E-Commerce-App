class ProductModel{
final int id;
final String title;
final double price;
final String category;
final double rating;
final String thumbnail;
final String description;
final double discountPercentage;
final int stock;

ProductModel({
  required this.id,
  required this.title,
  required this.price,
  required this.category,
  required this.rating,
  required this.thumbnail,
  required this.description,
  required this.discountPercentage,
  required this.stock,
});

factory ProductModel.fromJson(Map<String, dynamic> json) {

  return ProductModel(
    id: json['id'] as int,
    title: json['title'] as String,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String,
    rating: (json['rating'] as num).toDouble(),
    thumbnail: json['thumbnail'] as String,
    description: json['description'] as String? ?? '',
    discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
    stock: json['stock'] as int? ?? 0,
  );
}//Factory

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'category': category,
      'rating': rating,
      'thumbnail': thumbnail,
      'description': description,
      'discountPercentage': discountPercentage,
      'stock': stock,
    };
}
}//Class