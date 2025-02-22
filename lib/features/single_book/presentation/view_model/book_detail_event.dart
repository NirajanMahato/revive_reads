part of 'book_detail_bloc.dart';

abstract class BookDetailEvent extends Equatable {
  const BookDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchBookDetailEvent extends BookDetailEvent {
  final String bookId;

  const FetchBookDetailEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}
