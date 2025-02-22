import 'package:json_annotation/json_annotation.dart';
import 'package:revive_reads/features/single_book/data/model/book_detail_api_model.dart';

part 'book_detail_dto.g.dart';
// dart run build_runner build -d

@JsonSerializable()
class BookDetailDTO {
  final bool success;
  final BookDetailModel data;

  BookDetailDTO({
    required this.success,
    required this.data,
  });

  factory BookDetailDTO.fromJson(Map<String, dynamic> json) =>
      _$BookDetailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailDTOToJson(this);
}
