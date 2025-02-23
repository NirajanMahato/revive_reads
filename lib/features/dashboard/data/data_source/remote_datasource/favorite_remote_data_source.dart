import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/dashboard/data/data_source/favorite_data_source.dart';

class FavoriteRemoteDataSource implements IFavoriteDataSource {
  final Dio dio;

  FavoriteRemoteDataSource(this.dio);

  @override
  Future<void> addToFavorites(String bookId, String token) async {
    try {
      await dio.post(
        ApiEndpoints.addToFavorites,
        data: {'bookId': bookId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add to favorites');
    }
  }

  @override
  Future<void> removeFromFavorites(String bookId, String token) async {
    try {
      await dio.delete(
        '${ApiEndpoints.removeFromFavorites}/$bookId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to remove from favorites');
    }
  }
}