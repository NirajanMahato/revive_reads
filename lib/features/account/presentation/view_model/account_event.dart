part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class LoadAccount extends AccountEvent {
  final String userId;

  const LoadAccount(this.userId);

  @override
  List<Object> get props => [userId];
}

class LogoutRequested extends AccountEvent {}
