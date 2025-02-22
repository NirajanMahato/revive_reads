import 'package:equatable/equatable.dart';

abstract class PostBookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitBookEvent extends PostBookEvent {
  final String title;
  final String description;
  final double price;
  final String genre;
  final String condition;
  final List<String> images;
  final bool delivery;

  SubmitBookEvent({
    required this.title,
    required this.description,
    required this.price,
    required this.genre,
    required this.condition,
    required this.images,
    required this.delivery,
  });

  @override
  List<Object?> get props => [title, description, price, genre, condition, images, delivery];
}
