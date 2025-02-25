import 'package:revive_reads/features/message/data/model/message_model.dart';

abstract class IMessageDataSource {
  Future<List<MessageModel>> getMessages(String userId, String token);
  Future<MessageModel> sendMessage(String receiverId, String message, String token);
  Future<int> getUnreadMessageCount(String token);
}