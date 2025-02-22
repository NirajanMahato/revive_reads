import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/post_book/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/post_book/data/model/post_book_model.dart';
import 'package:revive_reads/features/post_book/domain/constants/book_constants.dart';

class PostBookRemoteDataSource implements IPostBookDataSource {
  final Dio dio;

  PostBookRemoteDataSource(this.dio);

  @override
  Future<void> postBook(PostBookModel book, String token) async {
    try {
      // Validate genre before sending
      if (!BookConstants.genres.contains(book.genre)) {
        throw Exception('Invalid genre: ${book.genre}');
      }

      // Validate condition before sending
      if (!BookConstants.conditions.contains(book.condition)) {
        throw Exception('Invalid condition: ${book.condition}');
      }

      var formData = FormData();

      // Add fields with validated data
      formData.fields.addAll([
        MapEntry('title', book.title),
        MapEntry('description', book.description),
        MapEntry('price', book.price.toString()),
        MapEntry('genre', book.genre),
        MapEntry('condition', book.condition),
        MapEntry('delivery', book.delivery.toString()),
      ]);

      // Add images with proper MIME type
      for (String imagePath in book.images) {
        final file = File(imagePath);
        final fileBytes = await file.readAsBytes();
        final filename = imagePath.split('/').last;

        formData.files.add(
          MapEntry(
            'images',
            MultipartFile.fromBytes(
              fileBytes,
              filename: filename,
              contentType:
                  MediaType('image', 'jpeg'), // or detect proper MIME type
            ),
          ),
        );
      }

      // Add logging
      print('Sending request with formData:');
      print('Fields: ${formData.fields}');
      print('Files count: ${formData.files.length}');

      final response = await dio.post(
        ApiEndpoints.postBook,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to post book: ${response.data}',
        );
      }

      print('Successfully posted book: ${response.data}');
    } catch (e) {
      print('Error in postBook: $e');
      if (e is DioException) {
        print('DioError response: ${e.response?.data}');
        print('DioError message: ${e.message}');
      }
      rethrow;
    }
  }
}
