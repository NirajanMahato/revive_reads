import 'package:revive_reads/features/my_ads/data/dto/my_book_dto.dart';

abstract class IMyAdsDataSource {
  Future<List<MyBookDTO>> getUserBooks(String token, String userId);
  Future<List<MyBookDTO>> getApprovedBooks(String token, String userId);
  Future<void> deleteBook(String bookId, String token);
  Future<void> markAsSold(String bookId, String token);
}
