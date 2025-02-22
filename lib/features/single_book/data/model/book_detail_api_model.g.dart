// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailModel _$BookDetailModelFromJson(Map<String, dynamic> json) =>
    BookDetailModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      condition: json['condition'] as String,
      price: (json['price'] as num).toDouble(),
      genre: json['genre'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      postedDate: DateTime.parse(json['approvalDate'] as String),
      seller: SellerModel.fromJson(json['seller'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookDetailModelToJson(BookDetailModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'genre': instance.genre,
      'price': instance.price,
      'description': instance.description,
      'images': instance.images,
      'condition': instance.condition,
      'approvalDate': instance.postedDate.toIso8601String(),
      'seller': instance.seller,
    };

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) => SellerModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'address': instance.address,
    };
