import 'package:revive_reads/features/post_book/data/model/post_book_model.dart';

abstract class IPostBookDataSource {
  Future<void> postBook(PostBookModel book, String token);
}
