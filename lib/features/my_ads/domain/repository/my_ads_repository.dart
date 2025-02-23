import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

abstract class IMyAdsRepository {
  Future<Either<Failure, List<MyBookEntity>>> getUserBooks();
  Future<Either<Failure, List<MyBookEntity>>> getApprovedBooks();
  Future<Either<Failure, void>> deleteBook(String bookId);
  Future<Either<Failure, void>> markAsSold(String bookId);
}
