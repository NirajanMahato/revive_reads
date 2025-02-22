import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';
import 'package:revive_reads/features/single_book/domain/repository/book_detail_repository.dart';

class GetBookDetailUseCase {
  final IBookDetailRepository repository;

  GetBookDetailUseCase(this.repository);

  Future<Either<Failure, BookDetailEntity>> call(String bookId) {
    return repository.getBookDetails(bookId);
  }
}
