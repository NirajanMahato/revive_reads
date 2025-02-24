import 'package:dartz/dartz.dart';
import 'package:revive_reads/core/error/failure.dart';
import 'package:revive_reads/features/notification/domain/repositiry/notification_repository.dart';

class MarkAsReadUseCase {
  final INotificationRepository repository;

  MarkAsReadUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markAsRead();
  }
}