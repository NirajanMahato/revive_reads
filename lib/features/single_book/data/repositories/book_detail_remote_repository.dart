import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/single_book/data/data_source/book_detail_datasource.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';
import 'package:revive_reads/features/single_book/domain/repository/book_detail_repository.dart';

class BookDetailRemoteRepository implements IBookDetailRepository {
  final IBookDetailDataSource dataSource;

  BookDetailRemoteRepository(this.dataSource);

  @override
  Future<Either<Failure, BookDetailEntity>> getBookDetails(
      String bookId) async {
    try {
      final bookDetailModel = await dataSource.getBookDetails(bookId);
      return Right(bookDetailModel.toEntity());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
