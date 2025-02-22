import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/dashboard/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';

class BookRemoteDataSource implements IBookDataSource {
  final Dio _dio;

  BookRemoteDataSource(this._dio);

  @override
  Future<List<BookEntity>> getAllBooks() async {
    try {
      final response = await _dio.get(ApiEndpoints.getApprovedBooks);
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => BookEntity(
                  id: json['_id'],
                  title: json['title'],
                  genre: json['genre'],
                  description: json['description'],
                  price: double.parse(json['price'].toString()),
                  condition: json['condition'],
                  delivery: json['delivery'],
                  sellerId: json['seller']['_id'],
                  images: List<String>.from(json['images']),
                ))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<BookEntity>> searchBooks(String query) async {
    try {
      final response =
          await _dio.get("${ApiEndpoints.getApprovedBooks}?search=$query");
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => BookEntity(
                  id: json['_id'],
                  title: json['title'],
                  genre: json['genre'],
                  description: json['description'],
                  price: double.parse(json['price'].toString()),
                  condition: json['condition'],
                  delivery: json['delivery'],
                  sellerId: json['seller']['_id'],
                  images: List<String>.from(json['images']),
                ))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
