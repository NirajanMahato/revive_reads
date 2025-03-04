import 'package:revive_reads/core/network/hive_service.dart';
import 'package:revive_reads/features/dashboard/data/data_source/book_data_source.dart';
import 'package:revive_reads/features/dashboard/data/model/book_api_model.dart';
import 'package:revive_reads/features/dashboard/data/model/book_hive_model.dart';

class BookLocalDataSource implements IBookDataSource {
  final HiveService _hiveService;
  
  BookLocalDataSource(this._hiveService);
  
  @override
  Future<List<BookModel>> getAllBooks() async {
    final books = await _hiveService.getAllBooks();
    return books.map((hiveBook) => hiveBook.toModel()).toList();
  }
  
  @override
  Future<List<BookModel>> searchBooks(String query) async {
    final books = await _hiveService.searchBooks(query);
    return books.map((hiveBook) => hiveBook.toModel()).toList();
  }
  
  // Additional methods for caching operations
  
  Future<void> cacheBooks(List<BookModel> books) async {
    final hiveBooks = books.map((model) => BookHiveModel.fromModel(model)).toList();
    await _hiveService.addBooks(hiveBooks);
  }
  
  Future<BookModel?> getBookById(String id) async {
    final hiveBook = await _hiveService.getBookById(id);
    return hiveBook?.toModel();
  }
  
  Future<bool> hasBooks() async {
    return await _hiveService.hasBooks();
  }
  
  Future<DateTime?> getLastCachedTime() async {
    return await _hiveService.getBooksLastCachedTime();
  }
}