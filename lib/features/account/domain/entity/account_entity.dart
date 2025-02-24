import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String avatar;
  final List<String> bookListings;
  final List<String> favorites;
  final String status;
  final DateTime createdAt;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.avatar,
    required this.bookListings,
    required this.favorites,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        address,
        avatar,
        bookListings,
        favorites,
        status,
        createdAt,
      ];
}