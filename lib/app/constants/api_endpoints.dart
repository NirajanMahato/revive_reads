class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 5000);
  static const String baseUrl = "http://10.0.2.2:5000/api/";

  // ====================== Auth Routes =========================
  static const String login = "user/sign-in";
  static const String register = "user/sign-up";
  static const String getAllUsers = "user/get-all-users";
  static const String getUserById = "user/get-user-by-id/:id";
  static const String deleteUser = "user/";
  static const String uploadImage = "user/uploadImage";

  static const String addToFavorites = "user/add-to-favorites";
  static const String removeFromFavorites = "user/remove-from-favorites/";

  static const String getBookByUser = "book/get-book-by-user";
  static const String getApprovedByUser = "book/get-book-by-user";
  static const String deleteBook = "book/delete-book";
  static const String markAsSold = "book/sold";
  
  // ====================== Book Routes =========================
  static const String getApprovedBooks = "book/get-approved-books";
  static const String getBookById = "book/get-book-by-id/";
  static const String postBook = "book/post-book/";
}
