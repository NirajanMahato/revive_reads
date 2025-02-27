import 'package:equatable/equatable.dart';

abstract class EditBookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateBookEvent extends EditBookEvent {
  final String bookId;
  final String title;
  final String description;
  final double price;
  final String genre;
  final String condition;
  final bool delivery;
  final List<String> newImages;
  final List<String> existingImages;

  UpdateBookEvent({
    required this.bookId,
    required this.title,
    required this.description,
    required this.price,
    required this.genre,
    required this.condition,
    required this.delivery,
    required this.newImages,
    required this.existingImages,
  });

  @override
  List<Object?> get props => [
        bookId,
        title,
        description,
        price,
        genre,
        condition,
        delivery,
        newImages,
        existingImages,
      ];
}