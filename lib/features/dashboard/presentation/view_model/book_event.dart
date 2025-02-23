abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {}

class SearchBooksEvent extends BookEvent {
  final String query;

  SearchBooksEvent(this.query);
}

class FilterByGenreEvent extends BookEvent {
  final String genre;

  FilterByGenreEvent(this.genre);

  @override
  List<Object?> get props => [genre];
}

class ToggleFavoriteEvent extends BookEvent {
  final String bookId;
  final bool isFavorite;

  ToggleFavoriteEvent({required this.bookId, required this.isFavorite});

  @override
  List<Object?> get props => [bookId, isFavorite];
}
