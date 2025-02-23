class MyBookEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String condition;
  final List<String> images;
  final String genre;
  final bool delivery;
  final String status;
  final bool sold;
  final DateTime createdAt;

  MyBookEntity({
    required this.id,
    required this.title,
    this.description = '', // Provide default value
    required this.price,
    required this.condition,
    required this.images,
    required this.genre,
    this.delivery = false, // Provide default value
    required this.status,
    this.sold = false, // Provide default value
    required this.createdAt,
  });
}