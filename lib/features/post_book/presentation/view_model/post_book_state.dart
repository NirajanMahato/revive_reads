import 'package:equatable/equatable.dart';

abstract class PostBookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostBookInitial extends PostBookState {}

class PostBookLoading extends PostBookState {}

class PostBookSuccess extends PostBookState {}

class PostBookFailure extends PostBookState {
  final String message;
  PostBookFailure(this.message);

  @override
  List<Object?> get props => [message];
}
