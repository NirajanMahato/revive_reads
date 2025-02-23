import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

abstract class MyAdsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyAdsInitial extends MyAdsState {}

class MyAdsLoading extends MyAdsState {}

class MyAdsLoaded extends MyAdsState {
  final List<MyBookEntity> books;

  MyAdsLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class MyAdsError extends MyAdsState {
  final String message;

  MyAdsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyAdsActionSuccess extends MyAdsState {
  final String message;

  MyAdsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}