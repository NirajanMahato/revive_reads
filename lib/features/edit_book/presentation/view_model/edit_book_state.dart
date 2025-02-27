import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

abstract class EditBookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditBookInitial extends EditBookState {}

class EditBookLoading extends EditBookState {}

class EditBookSuccess extends EditBookState {
  final MyBookEntity updatedBook;

  EditBookSuccess(this.updatedBook);

  @override
  List<Object?> get props => [updatedBook];
}

class EditBookFailure extends EditBookState {
  final String message;

  EditBookFailure(this.message);

  @override
  List<Object?> get props => [message];
}