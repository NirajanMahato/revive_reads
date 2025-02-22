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

  // ====================== Book Routes =========================
  static const String getApprovedBooks = "book/get-approved-books";
  static const String getBookById = "book/get-book-by-id/";
}
