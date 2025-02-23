class MyBookDTO {
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

  MyBookDTO({
    required this.id,
    required this.title,
    this.description = '',
    required this.price,
    required this.condition,
    required this.images,
    required this.genre,
    this.delivery = false,
    required this.status,
    this.sold = false,
    required this.createdAt,
  });

  factory MyBookDTO.fromJson(Map<String, dynamic> json) {
    return MyBookDTO(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      condition: json['condition'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      genre: json['genre'] ?? '',
      delivery: json['delivery'] ?? false,
      status: json['status'] ?? 'Pending',
      sold: json['sold'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
