import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/edit_book/data/data_source/edit_book_datasource.dart';
import 'package:revive_reads/features/edit_book/domain/repository/edit_book_repository.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

class EditBookRepository implements IEditBookRepository {
  final IEditBookDataSource dataSource;

  EditBookRepository(this.dataSource);

  @override
  Future<Either<Failure, MyBookEntity>> updateBook(
    String bookId,
    String title,
    String description,
    double price,
    String genre,
    String condition,
    bool delivery,
    List<String> newImages,
    List<String> existingImages,
    String token,
  ) async {
    try {
      final updatedBook = await dataSource.updateBook(
        bookId,
        title,
        description,
        price,
        genre,
        condition,
        delivery,
        newImages,
        existingImages,
        token,
      );
      return Right(updatedBook);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}