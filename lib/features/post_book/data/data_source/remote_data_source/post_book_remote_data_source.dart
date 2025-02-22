import 'package:dio/dio.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/post_book/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/post_book/data/model/post_book_model.dart';

class PostBookRemoteDataSource implements IPostBookDataSource {
  final Dio dio;

  PostBookRemoteDataSource(this.dio);

  @override
  Future<void> postBook(PostBookModel book, String token) async {
    try {
      // ✅ Prepare FormData with proper image handling
      final formData = FormData.fromMap({
        'title': book.title,
        'description': book.description,
        'price': book.price.toString(), // Convert price to String
        'genre': book.genre,
        'condition': book.condition,
        'delivery': book.delivery,
        'images': await Future.wait(book.images.map(
          (image) async {
            print("Uploading image from path: $image"); // Debugging log
            return await MultipartFile.fromFile(
              image,
              filename: image.split('/').last, // Extract filename correctly
            );
          },
        )),
      });

      // ✅ Make POST request with Authorization Header
      await dio.post(
        ApiEndpoints.postBook,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } on DioException catch (e) {
      // Log and throw error for better debugging
      print("Failed to post the book: ${e.response?.data ?? e.message}");
      throw Exception('Failed to post the book: ${e.response?.data}');
    }
  }
}
