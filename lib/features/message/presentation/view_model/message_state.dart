import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';

class MessageState extends Equatable {
  final bool isLoading;
  final List<MessageEntity> messages;
  final String? error;
  final int unreadCount;
  final List<String> onlineUsers;

  const MessageState({
    this.isLoading = false,
    this.messages = const [],
    this.error,
    this.unreadCount = 0,
    this.onlineUsers = const [],
  });

  MessageState copyWith({
    bool? isLoading,
    List<MessageEntity>? messages,
    String? error,
    int? unreadCount,
    List<String>? onlineUsers,
  }) {
    return MessageState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
      onlineUsers: onlineUsers ?? this.onlineUsers,
    );
  }

  @override
  List<Object?> get props => [isLoading, messages, error, unreadCount, onlineUsers];
}
