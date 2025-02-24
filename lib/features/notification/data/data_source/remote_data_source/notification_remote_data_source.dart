import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/notification/data/data_source/notification_data_source.dart';
import 'package:revive_reads/features/notification/data/model/notification_model.dart';

class NotificationRemoteDataSource implements INotificationDataSource {
  final Dio dio;

  NotificationRemoteDataSource(this.dio);

  @override
  Future<List<NotificationModel>> getNotifications(String token) async {
    try {
      final response = await dio.get(
        ApiEndpoints.notifications,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get notifications');
    }
  }

  @override
  Future<void> markAsRead(String token) async {
    try {
      await dio.put(
        ApiEndpoints.markNotificationsAsRead,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to mark as read');
    }
  }
}