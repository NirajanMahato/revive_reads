import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/dashboard/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/dashboard/data/model/book_api_model.dart';

class BookRemoteDataSource implements IBookDataSource {
  final Dio _dio;

  BookRemoteDataSource(this._dio);

  @override
  Future<List<BookModel>> getAllBooks() async {
    try {
      final response = await _dio.get(ApiEndpoints.getApprovedBooks);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => BookModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final response =
          await _dio.get("${ApiEndpoints.getApprovedBooks}?search=$query");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => BookModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
