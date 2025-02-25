import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';

abstract class IMessageRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages(String userId);
  Future<Either<Failure, MessageEntity>> sendMessage(String receiverId, String message);
  Future<Either<Failure, int>> getUnreadMessageCount();
  void initSocketConnection(String userId);
  void listenForNewMessages(Function(MessageEntity) onNewMessage);
  void listenForUnreadMessages(Function(bool) onUnreadUpdate);
  void listenForOnlineUsers(Function(List<String>) onOnlineUsers);
  void disconnectSocket();
}