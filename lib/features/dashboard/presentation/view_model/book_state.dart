import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookEntity> books;
  final List<BookEntity> allBooks;
  final String selectedGenre;
  final Set<String> favoriteBookIds;

  BookLoaded({
    required this.books,
    required this.allBooks,
    required this.selectedGenre,
    this.favoriteBookIds = const {},
  });

  @override
  List<Object?> get props => [books, allBooks, selectedGenre, favoriteBookIds];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteActionSuccess extends BookState {
  final String message;
  
  FavoriteActionSuccess(this.message);
  
  @override
  List<Object?> get props => [message];
}
