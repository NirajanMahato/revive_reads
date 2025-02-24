import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class MarkNotificationsAsReadEvent extends NotificationEvent {}
