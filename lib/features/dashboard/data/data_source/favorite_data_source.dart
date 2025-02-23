abstract interface class IFavoriteDataSource {
  Future<void> addToFavorites(String bookId, String token);
  Future<void> removeFromFavorites(String bookId, String token);
}
