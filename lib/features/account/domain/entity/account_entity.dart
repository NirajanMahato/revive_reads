import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String? avatar;

  const AccountEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    this.avatar,
  });

  // Create an empty constructor or Initial Constructor
  const AccountEntity.empty()
      : userId = '_empty.userId',
        fullName = '',
        email = '',
        phone = '',
        address = '',
        role = '',
        avatar = null;

  @override
  List<Object?> get props =>
      [userId, fullName, email, phone, address, role, avatar];
}
