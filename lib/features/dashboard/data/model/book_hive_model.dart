import 'package:hive_flutter/adapters.dart';
import 'package:revive_reads/app/constants/hive_table_constant.dart';
import 'package:revive_reads/features/dashboard/data/model/book_api_model.dart';

part 'book_hive_model.g.dart';
// dart run build_runner build -d

@HiveType(typeId: HiveTableConstant.bookBoxId)
class BookHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String genre;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String condition;

  @HiveField(6)
  final bool delivery;

  @HiveField(7)
  final String sellerId;

  @HiveField(8)
  final String sellerName;

  @HiveField(9)
  final List<String> images;

  BookHiveModel({
    required this.id,
    required this.title,
    required this.genre,
    required this.description,
    required this.price,
    required this.condition,
    required this.delivery,
    required this.sellerId,
    required this.sellerName,
    required this.images,
  });

  // Convert from BookModel to BookHiveModel
  factory BookHiveModel.fromModel(BookModel model) {
    return BookHiveModel(
      id: model.id,
      title: model.title,
      genre: model.genre,
      description: model.description,
      price: model.price,
      condition: model.condition,
      delivery: model.delivery,
      sellerId: model.sellerId,
      sellerName: model.sellerName,
      images: model.images,
    );
  }

  // Convert to BookModel
  BookModel toModel() {
    return BookModel(
      id: id,
      title: title,
      genre: genre,
      description: description,
      price: price,
      condition: condition,
      delivery: delivery,
      sellerId: sellerId,
      sellerName: sellerName,
      images: images,
    );
  }
}
