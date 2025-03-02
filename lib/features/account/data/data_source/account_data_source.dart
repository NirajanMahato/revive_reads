import 'dart:io';
import 'package:revive_reads/features/account/data/model/account_model.dart';

abstract class IAccountDataSource {
  Future<AccountModel> getAccount(String userId, String token);
  Future<AccountModel> updateProfile({
    required String userId,
    required String name,
    required String phone,
    required String address,
    File? avatar,
    required String token,
  });
}