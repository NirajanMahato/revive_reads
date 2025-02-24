import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/notification/domain/entity/notification_entity.dart';
import 'package:revive_reads/features/notification/domain/repositiry/notification_repository.dart';

class GetNotificationsUseCase {
  final INotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}