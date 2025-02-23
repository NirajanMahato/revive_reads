import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';
import 'package:revive_reads/features/my_ads/domain/repository/my_ads_repository.dart';

class GetUserBooksUseCase {
  final IMyAdsRepository repository;

  GetUserBooksUseCase(this.repository);

  Future<Either<Failure, List<MyBookEntity>>> call() async {
    return await repository.getUserBooks();
  }
}