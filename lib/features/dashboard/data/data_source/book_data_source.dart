import 'package:revive_reads/features/dashboard/data/model/book_api_model.dart';

abstract interface class IBookDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<List<BookModel>> searchBooks(String query);
}
