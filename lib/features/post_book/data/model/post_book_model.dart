import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';

class PostBookModel {
  final String title;
  final String description;
  final double price;
  final String genre;
  final String condition;
  final List<String> images;
  final bool delivery;

  PostBookModel({
    required this.title,
    required this.description,
    required this.price,
    required this.genre,
    required this.condition,
    required this.images,
    required this.delivery,
  });

  factory PostBookModel.fromEntity(PostBookEntity entity) {
    return PostBookModel(
      title: entity.title,
      description: entity.description,
      price: entity.price,
      genre: entity.genre,
      condition: entity.condition,
      images: entity.images,
      delivery: entity.delivery,
    );
  }
}
