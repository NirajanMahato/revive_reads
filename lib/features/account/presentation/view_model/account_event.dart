part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

final class LoadUser extends AccountEvent {
  final String userId;

  const LoadUser(this.userId);

  @override
  List<Object> get props => [userId];
}
