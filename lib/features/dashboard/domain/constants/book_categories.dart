class CategoryItem {
  final String value;
  final String label;
  
  CategoryItem(this.value, this.label);
}

final List<CategoryItem> categories = [
  CategoryItem('All', '📚 All'),
  CategoryItem('Arts & Photography', '🎨 Arts'),
  CategoryItem('Fiction', '📖 Fiction'),
  CategoryItem('Non Fiction & Biography', '📚 Non-Fiction'),
  CategoryItem('Educational Textbook', '📘 Education'),
  CategoryItem('Magazines & Comics', '🗂 Magazines'),
  CategoryItem('Technology', '💻 Technology'),
  CategoryItem('Romance', '💝 Romance'),
  CategoryItem('Other', '✨ Other'),
];