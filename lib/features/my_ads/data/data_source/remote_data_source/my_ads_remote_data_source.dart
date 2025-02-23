import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/my_ads/data/data_source/my_ads_data_source.dart';
import 'package:revive_reads/features/my_ads/data/dto/my_book_dto.dart';

class MyAdsRemoteDataSource implements IMyAdsDataSource {
  final Dio dio;

  MyAdsRemoteDataSource(this.dio);

  @override
  Future<List<MyBookDTO>> getUserBooks(String token, String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getBookByUser,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'id': userId,  // Add user ID to headers
          },
        ),
      );
      
      final List<MyBookDTO> books = (response.data as List)
          .map((book) => MyBookDTO.fromJson(book))
          .toList();
      
      return books;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch books');
    }
  }

  @override
  Future<List<MyBookDTO>> getApprovedBooks(String token, String userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getApprovedByUser,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'id': userId,  // Add user ID to headers
          },
        ),
      );
      
      final List<MyBookDTO> books = (response.data as List)
          .map((book) => MyBookDTO.fromJson(book))
          .toList();
      
      return books;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch books');
    }
  }

  @override
  Future<void> deleteBook(String bookId, String token) async {
    try {
      await dio.delete(
        ApiEndpoints.deleteBook,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'bookid': bookId,
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete book');
    }
  }

  @override
  Future<void> markAsSold(String bookId, String token) async {
    try {
      await dio.patch(
        '${ApiEndpoints.markAsSold}/$bookId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to mark as sold');
    }
  }
}
