import 'package:revive_reads/features/account/domain/entity/account_entity.dart';

class AccountModel {
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

  AccountModel({
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

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'] ?? 'default_avatar.png',
      bookListings: List<String>.from(json['book_listings'] ?? []),
      favorites: List<String>.from(json['favorites'] ?? []),
      status: json['status'] ?? 'Offline',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      avatar: avatar,
      bookListings: bookListings,
      favorites: favorites,
      status: status,
      createdAt: createdAt,
    );
  }
}
