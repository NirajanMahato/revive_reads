
import 'package:revive_reads/features/single_book/data/model/book_detail_api_model.dart';

abstract class IBookDetailDataSource {
  Future<BookDetailModel> getBookDetails(String bookId);
}
