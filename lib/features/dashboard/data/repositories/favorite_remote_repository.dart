import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/data/data_source/favorite_data_source.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/favorite_repository.dart';

class FavoriteRemoteRepository implements IFavoriteRepository {
  final IFavoriteDataSource dataSource;

  FavoriteRemoteRepository(this.dataSource);

  @override
  Future<Either<Failure, void>> addToFavorites(String bookId, String token) async {
    try {
      await dataSource.addToFavorites(bookId, token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String bookId, String token) async {
    try {
      await dataSource.removeFromFavorites(bookId, token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}