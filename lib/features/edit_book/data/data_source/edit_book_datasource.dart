import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

abstract class IEditBookDataSource {
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
  );
}
