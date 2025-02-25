import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';

class InitSocketUseCase {
  final IMessageRepository repository;

  InitSocketUseCase(this.repository);

  void call(String userId) {
    repository.initSocketConnection(userId);
  }
}