import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/post_book/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/post_book/data/model/post_book_model.dart';
import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';
import 'package:revive_reads/features/post_book/domain/repository/post_book_repository.dart';


class PostBookRemoteRepository implements IPostBookRepository {
  final IPostBookDataSource dataSource;

  PostBookRemoteRepository(this.dataSource);

  @override
  Future<Either<Failure, void>> postBook(PostBookEntity book, String token) async {
    try {
      final model = PostBookModel.fromEntity(book);
      await dataSource.postBook(model, token);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
