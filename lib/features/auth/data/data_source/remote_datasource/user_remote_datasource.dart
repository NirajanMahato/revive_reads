import 'dart:io';

import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/auth/data/data_source/user_data_source.dart';
import 'package:revive_reads/features/auth/data/dto/get_all_user_dto.dart';
import 'package:revive_reads/features/auth/data/dto/get_user_by_id_dto.dart';
import 'package:revive_reads/features/auth/data/model/user_api_model.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';

class UserRemoteDataSource implements IUserDataSource {
  final Dio _dio;
  UserRemoteDataSource(this._dio);

  @override
  Future<void> createUser(UserEntity userEntity) async {
    try {
      // Convert entity to model
      var userApiModel = UserApiModel.fromEntity(userEntity);
      var response = await _dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteUser(String id, String? token) async {
    try {
      var response = await _dio.delete(
        ApiEndpoints.deleteUser + id,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try {
      var response = await _dio.get(ApiEndpoints.getAllUsers);
      if (response.statusCode == 200) {
        GetAllUserDTO userAddDTO = GetAllUserDTO.fromJson(response.data);
        return UserApiModel.toEntityList(userAddDTO.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.getUserById.replaceFirst(":id", userId));
      if (response.statusCode == 200) {
        GetUserByIdDTO userDTO = GetUserByIdDTO.fromJson(response.data);
        return userDTO.data.toEntity();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, String>> loginUser(String email, String password) async {
    try {
      Response response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final String id =
            response.data['user']['id'].toString(); // Ensure String
        final String token =
            response.data['user']['token'].toString(); // Ensure String
        return {'id': id, 'token': token};
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'avatar': await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        },
      );

      Response response = await _dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }
}
