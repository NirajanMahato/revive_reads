import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String title;
  final String genre;
  final String description;
  final double price;
  final String condition;
  final bool delivery;
  final String sellerId;
  final List<String> images;

  const BookEntity({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.price,
    required this.condition,
    required this.delivery,
    required this.sellerId,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        genre,
        description,
        price,
        condition,
        delivery,
        sellerId,
        images
      ];
}
