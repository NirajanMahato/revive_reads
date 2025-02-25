import 'package:dartz/dartz.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/message/data/data_source/message_data_source.dart';
import 'package:revive_reads/features/message/data/data_source/remote_data_source/socket_service.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';

class MessageRemoteRepository implements IMessageRepository {
  final IMessageDataSource dataSource;
  final TokenSharedPrefs tokenSharedPrefs;
  final SocketService socketService;

  MessageRemoteRepository(
    this.dataSource,
    this.tokenSharedPrefs,
    this.socketService,
  );

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String userId) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            final messages = await dataSource.getMessages(userId, token);
            return Right(messages.map((model) => model.toEntity()).toList());
          } catch (e) {
            return Left(ApiFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String receiverId, String message) async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            final newMessage = await dataSource.sendMessage(receiverId, message, token);
            return Right(newMessage.toEntity());
          } catch (e) {
            return Left(ApiFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadMessageCount() async {
    try {
      final tokenResult = await tokenSharedPrefs.getToken();
      
      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          try {
            final unreadCount = await dataSource.getUnreadMessageCount(token);
            return Right(unreadCount);
          } catch (e) {
            return Left(ApiFailure(message: e.toString()));
          }
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  void initSocketConnection(String userId) {
    socketService.initSocket(userId);
  }

  @override
  void listenForNewMessages(Function(MessageEntity) onNewMessage) {
    socketService.onNewMessage((message) {
      onNewMessage(message.toEntity());
    });
  }

  @override
  void listenForUnreadMessages(Function(bool) onUnreadUpdate) {
    socketService.onUpdateUnreadMessages(onUnreadUpdate);
  }

  @override
  void listenForOnlineUsers(Function(List<String>) onOnlineUsers) {
    socketService.onOnlineUsers(onOnlineUsers);
  }

  @override
  void disconnectSocket() {
    socketService.disconnect();
  }
}