import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBooksEvent extends BookEvent {}

class SearchBooksEvent extends BookEvent {
  final String query;

  SearchBooksEvent(this.query);

  @override
  List<Object?> get props => [query];
}
