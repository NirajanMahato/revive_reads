class PostBookEntity {
  final String title;
  final String description;
  final double price;
  final String genre;
  final String condition;
  final List<String> images;
  final bool delivery;

  PostBookEntity({
    required this.title,
    required this.description,
    required this.price,
    required this.genre,
    required this.condition,
    required this.images,
    required this.delivery,
  });
}
