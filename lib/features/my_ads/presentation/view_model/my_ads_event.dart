import 'package:equatable/equatable.dart';

abstract class MyAdsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserBooksEvent extends MyAdsEvent {}

class DeleteBookEvent extends MyAdsEvent {
  final String bookId;

  DeleteBookEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class MarkBookAsSoldEvent extends MyAdsEvent {
  final String bookId;

  MarkBookAsSoldEvent(this.bookId);

  @override
  List<Object?> get props => [bookId];
}