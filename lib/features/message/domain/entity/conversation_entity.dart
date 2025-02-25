import 'package:equatable/equatable.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<String> participants;
  final List<MessageEntity> messages;
  final bool hasUnread;
  final String? lastMessageId;
  final MessageEntity? lastMessage;

  const ConversationEntity({
    required this.id,
    required this.participants,
    required this.messages,
    required this.hasUnread,
    this.lastMessageId,
    this.lastMessage,
  });

  @override
  List<Object?> get props => [id, participants, messages, hasUnread, lastMessageId, lastMessage];
}