import 'dart:io';

import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<void> createUser(UserEntity userEntity);
  Future<Map<String, String>> loginUser(
      String email, String password); // Must match
  Future<List<UserEntity>> getAllUsers();
  Future<UserEntity> getUserById(String userId);
  Future<void> deleteUser(String id, String? token);
  Future<String> uploadProfilePicture(File file);
}
