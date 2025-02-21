import 'dart:io';

import 'package:revive_reads/core/network/hive_service.dart';
import 'package:revive_reads/features/auth/data/data_source/user_data_source.dart';
import 'package:revive_reads/features/auth/data/model/user_hive_model.dart';
import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';

class UserLocalDataSource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDataSource(this._hiveService);

  @override
  Future<void> createUser(UserEntity userEntity) async {
    try {
      // Convert UserEntity to UserHiveModel
      final userHiveModel = UserHiveModel.fromEntity(userEntity);
      await _hiveService.addUser(userHiveModel);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, String>> loginUser(String email, String password) async {
    try {
      final UserHiveModel? user = await _hiveService.login(email, password);

      if (user != null) {
        return {
          'id': user.userId ?? '', // Ensure `userId` is used correctly
          'token': user
              .role, // Temporary placeholder, replace with actual token if available
        };
      } else {
        throw Exception("Invalid credentials");
      }
    } catch (e) {
      throw Exception("Error logging in: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteUser(String id, String? token) async {
    try {
      return await _hiveService.deleteUser(id);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() {
    try {
      return _hiveService.getAllUsers().then((value) {
        return value.map((e) => e.toEntity()).toList();
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    // TODO: implement uploadProfilePicture
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getUserById(String userId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }
}
