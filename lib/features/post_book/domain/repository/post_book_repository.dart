import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/post_book/domain/entity/post_book_entity.dart';


abstract class IPostBookRepository {
  Future<Either<Failure, void>> postBook(PostBookEntity book, String token);
}
