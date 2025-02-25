import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool read;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, senderId, receiverId, message, read, createdAt];
}