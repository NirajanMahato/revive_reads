import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/notification/data/data_source/notification_data_source.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/features/notification/domain/entity/notification_entity.dart';
import 'package:revive_reads/features/notification/domain/repositiry/notification_repository.dart';

class NotificationRemoteRepository implements INotificationRepository {
  final INotificationDataSource dataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  NotificationRemoteRepository(this.dataSource, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          final notifications = await dataSource.getNotifications(token);
          return Right(notifications.map((model) => model.toEntity()).toList());
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead() async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          await dataSource.markAsRead(token);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}