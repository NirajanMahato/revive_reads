import 'package:revive_reads/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserDataSource{
  Future< void> createUser(UserEntity userEntity);
  Future<String> loginUser(String email, String password);
  Future< List<UserEntity>> getAllUsers();
  Future<void> deleteUser(String id);
}
