import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';

class BookModel {
  final String id;
  final String title;
  final String genre;
  final String description;
  final double price;
  final String condition;
  final bool delivery;
  final String sellerId;
  final String sellerName;
  final List<String> images;

  BookModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.price,
    required this.condition,
    required this.delivery,
    required this.sellerId,
    required this.sellerName,
    required this.images,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      condition: json['condition'] ?? '',
      delivery: json['delivery'] ?? false,
      sellerId: json['seller']['_id'] ?? '',
      sellerName: json['seller']['name'] ?? 'Unknown Seller',
      images: List<String>.from(json['images'] ?? []),
    );
  }

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      genre: genre,
      description: description,
      price: price,
      condition: condition,
      delivery: delivery,
      sellerId: sellerId,
      sellerName: sellerName,
      images: images,
    );
  }
}
