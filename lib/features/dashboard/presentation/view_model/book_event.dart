
abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {}

class SearchBooksEvent extends BookEvent {
  final String query;

  SearchBooksEvent(this.query);
}

class FilterByGenreEvent extends BookEvent {
  final String genre;

  FilterByGenreEvent(this.genre);
}

