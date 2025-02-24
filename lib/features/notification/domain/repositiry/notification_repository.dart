import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/notification/domain/entity/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead();
}