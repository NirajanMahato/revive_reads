class BookDetailEntity {
  final String id;
  final String title;
  final String genre;
  final double price;
  final String description;
  final List<String> images;
  final String condition;
  final DateTime postedDate;
  final String sellerName;
  final String sellerEmail;
  final String sellerAvatar;
  final String? sellerAddress;

  BookDetailEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.condition,
    required this.price,
    required this.genre,
    required this.images,
    required this.postedDate,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerAvatar,
    this.sellerAddress,
  });
}
