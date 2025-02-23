import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/my_ads/domain/repository/my_ads_repository.dart';

class DeleteBookUseCase {
  final IMyAdsRepository repository;

  DeleteBookUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookId) async {
    return await repository.deleteBook(bookId);
  }
}
