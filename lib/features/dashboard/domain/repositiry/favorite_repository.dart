import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';

abstract interface class IFavoriteRepository {
  Future<Either<Failure, void>> addToFavorites(String bookId, String token);
  Future<Either<Failure, void>> removeFromFavorites(String bookId, String token);
}