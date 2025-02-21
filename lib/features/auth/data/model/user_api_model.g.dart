// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
      userId: json['_id'] as String?,
      fullName: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String?,
      phone: json['phone'] as String,
      address: json['address'] as String,
      role: json['role'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      'name': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'phone': instance.phone,
      'address': instance.address,
      'role': instance.role,
      'avatar': instance.avatar,
    };
