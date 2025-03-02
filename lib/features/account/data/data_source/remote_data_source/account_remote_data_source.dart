import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/account/data/data_source/account_data_source.dart';
import 'package:revive_reads/features/account/data/model/account_model.dart';

class AccountRemoteDataSource implements IAccountDataSource {
  final Dio dio;

  AccountRemoteDataSource(this.dio);

  @override
  Future<AccountModel> getAccount(String userId, String token) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.getUserById}/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get account details');
    }
  }

  @override
  Future<AccountModel> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
    File? avatar,
    required String token,
  }) async {
    try {
      FormData formData = FormData();
      
      // Add text fields
      formData.fields.add(MapEntry('name', name));
      formData.fields.add(MapEntry('phone', phone));
      formData.fields.add(MapEntry('address', address));
      
      // Add file if exists
      if (avatar != null) {
        String fileName = avatar.path.split('/').last;
        String extension = fileName.split('.').last.toLowerCase();
        MediaType contentType;
        
        if (extension == 'jpg' || extension == 'jpeg') {
          contentType = MediaType('image', 'jpeg');
        } else if (extension == 'png') {
          contentType = MediaType('image', 'png');
        } else {
          contentType = MediaType('application', 'octet-stream');
        }
        
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            avatar.path,
            filename: fileName,
            contentType: contentType,
          ),
        ));
      }
      
      final response = await dio.patch(
        ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      return AccountModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update profile');
    }
  }
}