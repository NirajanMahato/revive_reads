import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/edit_book/domain/repository/edit_book_repository.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

class UpdateBookUseCase {
  final IEditBookRepository repository;

  UpdateBookUseCase(this.repository);

  Future<Either<Failure, MyBookEntity>> call(
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
    return repository.updateBook(
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
  }
}