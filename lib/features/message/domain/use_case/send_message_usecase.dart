import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';

class SendMessageUseCase {
  final IMessageRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, MessageEntity>> call(String receiverId, String message) async {
    return await repository.sendMessage(receiverId, message);
  }
}