import 'package:revive_reads/features/account/data/model/account_model.dart';

abstract class IAccountDataSource {
  Future<AccountModel> getAccount(String userId, String token);
}
