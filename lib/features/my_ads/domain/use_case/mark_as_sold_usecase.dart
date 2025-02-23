import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/my_ads/domain/repository/my_ads_repository.dart';

class MarkAsSoldUseCase {
  final IMyAdsRepository repository;

  MarkAsSoldUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookId) async {
    return await repository.markAsSold(bookId);
  }
}