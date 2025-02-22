import 'package:json_annotation/json_annotation.dart';
import 'package:revive_reads/features/single_book/domain/entity/book_detail_entity.dart';

part 'book_detail_api_model.g.dart';

@JsonSerializable()
class BookDetailModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String genre;
  final double price;
  final String description;
  final List<String> images;
  final String condition;

  @JsonKey(name: 'approvalDate')
  final DateTime postedDate;

  final SellerModel seller;

  BookDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.condition,
    required this.price,
    required this.genre,
    required this.images,
    required this.postedDate,
    required this.seller,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BookDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailModelToJson(this);

  // Convert Model to Entity
  BookDetailEntity toEntity() {
    return BookDetailEntity(
      id: id,
      title: title,
      description: description,
      condition: condition,
      price: price,
      genre: genre,
      images: images,
      postedDate: postedDate,
      sellerName: seller.name,
      sellerEmail: seller.email,
      sellerAvatar: seller.avatar,
      sellerAddress: seller.address ?? "No address provided",
    );
  }
}

@JsonSerializable()
class SellerModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String? address;

  SellerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.address,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
