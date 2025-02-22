import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';
import 'package:revive_reads/features/post_book/domain/repository/post_book_repository.dart';


class PostBookUseCase {
  final IPostBookRepository repository;

  PostBookUseCase(this.repository);

  Future<Either<Failure, void>> call(PostBookEntity book, String token) async {
    return await repository.postBook(book, token);
  }
}
