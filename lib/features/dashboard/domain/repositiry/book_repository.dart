import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';

abstract class IBookRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks();
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query);
}
