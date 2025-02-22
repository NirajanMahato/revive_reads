import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/single_book/data/data_source/book_detail_datasource.dart';
import 'package:revive_reads/features/single_book/data/model/book_detail_api_model.dart';

class BookDetailRemoteDataSource implements IBookDetailDataSource {
  final Dio _dio;

  BookDetailRemoteDataSource(this._dio);

  @override
  Future<BookDetailModel> getBookDetails(String bookId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.getBookById}/$bookId');
      print("Response Data: ${response.data}");

      return BookDetailModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch book details: $e');
    }
  }
}
