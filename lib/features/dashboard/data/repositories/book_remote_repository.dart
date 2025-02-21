import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/dashboard/data/data_source/remote_datasource/book_remote_datasource.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';
import 'package:revive_reads/features/dashboard/domain/repositiry/book_repository.dart';

class BookRemoteRepository implements IBookRepository {
  final BookRemoteDataSource remoteDataSource;

  BookRemoteRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    try {
      final books = await remoteDataSource.getAllBooks();
      return Right(books);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    try {
      final books = await remoteDataSource.searchBooks(query);
      return Right(books);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
