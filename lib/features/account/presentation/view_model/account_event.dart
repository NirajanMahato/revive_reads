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

final class LogoutRequested extends AccountEvent {}

final class UpdateProfile extends AccountEvent {
  final String userId;
  final String name;
  final String phone;
  final String address;
  final File? avatar;

  const UpdateProfile({
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    this.avatar,
  });

  @override
  List<Object> get props => [userId, name, phone, address];
}