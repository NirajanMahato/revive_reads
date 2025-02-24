import 'package:dio/dio.dart';
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
}