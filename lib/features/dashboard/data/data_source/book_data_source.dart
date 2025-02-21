import 'package:revive_reads/features/dashboard/domain/entity/book_entity.dart';

abstract interface class IBookDataSource{
  Future<List<BookEntity>> getAllBooks();
  Future<List<BookEntity>> searchBooks(String query);
}