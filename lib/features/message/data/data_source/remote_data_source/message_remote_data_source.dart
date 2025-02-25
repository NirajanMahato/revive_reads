import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/message/data/data_source/message_data_source.dart';
import 'package:revive_reads/features/message/data/model/message_model.dart';

class MessageRemoteDataSource implements IMessageDataSource {
  final Dio dio;

  MessageRemoteDataSource(this.dio);

  @override
  Future<List<MessageModel>> getMessages(String userId, String token) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.messages}/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return (response.data as List)
          .map((message) => MessageModel.fromJson(message))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get messages');
    }
  }

  @override
  Future<MessageModel> sendMessage(
      String receiverId, String message, String token) async {
    try {
      final response = await dio.post(
        '${ApiEndpoints.messages}/send/$receiverId',
        data: {'message': message},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return MessageModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send message');
    }
  }

  @override
  Future<int> getUnreadMessageCount(String token) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.messages}/unread',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.data['unreadCount'];
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? 'Failed to get unread count');
    }
  }
}
