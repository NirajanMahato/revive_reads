import 'package:dartz/dartz.dart';
import 'package:revive_reads/app/usecase/usecase.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/book_repository.dart';

class GetBooksUseCase implements UsecaseWithoutParams<List<BookEntity>> {
  final IBookRepository repository;

  GetBooksUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call() {
    return repository.getAllBooks();
  }
}
