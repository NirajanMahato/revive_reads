// lib/features/edit_book/data/datasource/edit_book_datasource.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/edit_book/data/data_source/edit_book_datasource.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

class EditBookRemoteDataSource implements IEditBookDataSource {
  final Dio dio;

  EditBookRemoteDataSource(this.dio);

  @override
  Future<MyBookEntity> updateBook(
    String bookId,
    String title,
    String description,
    double price,
    String genre,
    String condition,
    bool delivery,
    List<String> newImages,
    List<String> existingImages,
    String token,
  ) async {
    try {
      // Prepare FormData with updated book details
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry('title', title),
        MapEntry('description', description),
        MapEntry('price', price.toString()),
        MapEntry('genre', genre),
        MapEntry('condition', condition),
        MapEntry('delivery', delivery.toString()),
        // Also add existing images to keep track
        for (var i = 0; i < existingImages.length; i++)
          MapEntry('existingImages', existingImages[i]),
      ]);

      // Add new images if any
      for (var imagePath in newImages) {
        final file = File(imagePath);
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              imagePath,
              filename: imagePath.split('/').last,
            ),
          ),
        );
      }

      // Make the request
      final response = await dio.patch(
        '${ApiEndpoints.updateBook}/$bookId',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        // Convert response data to MyBookEntity
        final json = response.data['data'];
        return MyBookEntity(
          id: json['_id'],
          title: json['title'],
          description: json['description'],
          price: json['price'].toDouble(),
          genre: json['genre'],
          condition: json['condition'],
          delivery: json['delivery'],
          images: List<String>.from(json['images']),
          status: json['status'],
          sold: json['sold'],
          createdAt: DateTime.parse(json['createdAt']),
        );
      } else {
        throw Exception('Failed to update book: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update book');
    }
  }
}
