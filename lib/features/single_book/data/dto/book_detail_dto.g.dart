// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailDTO _$BookDetailDTOFromJson(Map<String, dynamic> json) =>
    BookDetailDTO(
      success: json['success'] as bool,
      data: BookDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookDetailDTOToJson(BookDetailDTO instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
