import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/message/domain/entity/message_entity.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';

class GetMessagesUseCase {
  final IMessageRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(String userId) async {
    return await repository.getMessages(userId);
  }
}
