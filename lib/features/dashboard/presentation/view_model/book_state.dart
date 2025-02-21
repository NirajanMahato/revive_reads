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

  BookLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}
