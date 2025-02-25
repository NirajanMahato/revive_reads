import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class InitializeSocketEvent extends MessageEvent {
  final String userId;

  const InitializeSocketEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadMessagesEvent extends MessageEvent {
  final String userId;

  const LoadMessagesEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SendMessageEvent extends MessageEvent {
  final String receiverId;
  final String message;

  const SendMessageEvent({
    required this.receiverId,
    required this.message,
  });

  @override
  List<Object?> get props => [receiverId, message];
}

class GetUnreadCountEvent extends MessageEvent {}

class NewMessageReceivedEvent extends MessageEvent {
  final MessageEntity message;

  const NewMessageReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateOnlineUsersEvent extends MessageEvent {
  final List<String> onlineUsers;

  const UpdateOnlineUsersEvent(this.onlineUsers);

  @override
  List<Object?> get props => [onlineUsers];
}
