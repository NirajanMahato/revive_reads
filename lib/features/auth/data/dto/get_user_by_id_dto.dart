import 'package:json_annotation/json_annotation.dart';
import 'package:revive_reads/features/auth/data/model/user_api_model.dart';

part 'get_user_by_id_dto.g.dart';
// dart run build_runner build -d


@JsonSerializable()
class GetUserByIdDTO {
  final bool success;
  final UserApiModel data;

  GetUserByIdDTO({
    required this.success,
    required this.data,
  });

  // toJson converts the object to a JSON map
  Map<String, dynamic> toJson() => _$GetUserByIdDTOToJson(this);

  // fromJson is a factory method that converts a JSON map to the object
  factory GetUserByIdDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserByIdDTOFromJson(json);
}
