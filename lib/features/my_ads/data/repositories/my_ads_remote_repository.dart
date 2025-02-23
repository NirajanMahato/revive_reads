import 'package:dartz/dartz.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/my_ads/data/data_source/my_ads_data_source.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';
import 'package:revive_reads/features/my_ads/domain/repository/my_ads_repository.dart';

class MyAdsRemoteRepository implements IMyAdsRepository {
  final IMyAdsDataSource dataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  MyAdsRemoteRepository(this.dataSource, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, List<MyBookEntity>>> getUserBooks() async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      final userIdResult = await tokenSharedPrefs.getUserId();

      if (tokenResult.isLeft() || userIdResult.isLeft()) {
        return const Left(
            SharedPrefsFailure(message: 'Failed to get user credentials'));
      }

      final token = tokenResult.getOrElse(() => '');
      final userId = userIdResult.getOrElse(() => '');

      if (token.isEmpty || userId.isEmpty) {
        return const Left(SharedPrefsFailure(message: 'User not logged in'));
      }

      final dtos = await dataSource.getUserBooks(token, userId);
      final entities = dtos
          .map((dto) => MyBookEntity(
                id: dto.id,
                title: dto.title,
                description: dto.description,
                price: dto.price,
                condition: dto.condition,
                images: dto.images,
                genre: dto.genre,
                delivery: dto.delivery,
                status: dto.status,
                sold: dto.sold,
                createdAt: dto.createdAt,
              ))
          .toList();

      return Right(entities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MyBookEntity>>> getApprovedBooks() async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      final userIdResult = await tokenSharedPrefs.getUserId();

      if (tokenResult.isLeft() || userIdResult.isLeft()) {
        return const Left(
            SharedPrefsFailure(message: 'Failed to get user credentials'));
      }

      final token = tokenResult.getOrElse(() => '');
      final userId = userIdResult.getOrElse(() => '');

      if (token.isEmpty || userId.isEmpty) {
        return const Left(SharedPrefsFailure(message: 'User not logged in'));
      }

      final dtos = await dataSource.getApprovedBooks(token, userId);
      final entities = dtos
          .map((dto) => MyBookEntity(
                id: dto.id,
                title: dto.title,
                description: dto.description,
                price: dto.price,
                condition: dto.condition,
                images: dto.images,
                genre: dto.genre,
                delivery: dto.delivery,
                status: dto.status,
                sold: dto.sold,
                createdAt: dto.createdAt,
              ))
          .toList();

      return Right(entities);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBook(String bookId) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          await dataSource.deleteBook(bookId, token);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsSold(String bookId) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          await dataSource.markAsSold(bookId, token);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
