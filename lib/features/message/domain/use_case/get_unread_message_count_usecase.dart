import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';

class GetUnreadMessageCountUseCase {
  final IMessageRepository repository;

  GetUnreadMessageCountUseCase(this.repository);

  Future<Either<Failure, int>> call() async {
    return await repository.getUnreadMessageCount();
  }
}
