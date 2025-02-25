import 'package:revive_reads/features/message/domain/entity/message_entity.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool read;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      read: read,
      createdAt: createdAt,
    );
  }
}