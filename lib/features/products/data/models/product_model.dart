class ProductModel{
final int id;
final String title;
final double price;
final String category;
final double rating;
final String thumbnail;

ProductModel({
  required this.id,
  required this.title,
  required this.price,
  required this.category,
  required this.rating,
  required this.thumbnail,
});

factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] as int,
    title: json['title'] as String,
    price: (json['price'] as num).toDouble(),
    category: json['category'] as String,
    rating: (json['rating'] as num).toDouble(),
    thumbnail: json['thumbnail'] as String,
  );
}//Factory
}//Class