import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/favorite_repository.dart';

class AddToFavoritesUseCase {
  final IFavoriteRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookId, String token) async {
    return await repository.addToFavorites(bookId, token);
  }
}

class RemoveFromFavoritesUseCase {
  final IFavoriteRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookId, String token) async {
    return await repository.removeFromFavorites(bookId, token);
  }
}