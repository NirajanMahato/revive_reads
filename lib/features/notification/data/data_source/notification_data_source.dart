import 'package:revive_reads/features/notification/data/model/notification_model.dart';

abstract interface class INotificationDataSource {
  Future<List<NotificationModel>> getNotifications(String token);
  Future<void> markAsRead(String token);
}