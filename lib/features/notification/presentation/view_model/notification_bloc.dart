import 'package:bloc/bloc.dart';
import 'package:revive_reads/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:revive_reads/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_event.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAsReadUseCase markAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationsAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> _onMarkAsRead(
    MarkNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await markAsReadUseCase();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) async {
        final notificationsResult = await getNotificationsUseCase();
        notificationsResult.fold(
          (failure) => emit(NotificationError(failure.message)),
          (notifications) => emit(NotificationLoaded(notifications)),
        );
      },
    );
  }
}
