import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';

abstract class IBookDetailRepository {
  Future<Either<Failure, BookDetailEntity>> getBookDetails(String bookId);
}
