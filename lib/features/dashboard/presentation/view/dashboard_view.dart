import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:revive_reads/features/dashboard/domain/constants/book_categories.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_bloc.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';
import 'package:revive_reads/features/single_book/presentation/view/book_detail_view.dart';

class DashboardView extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Notification Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/logo/Logo2.png',
                      height: 40,
                    ),
                    IconButton(
                      onPressed: () {
                        // Handle notifications
                      },
                      icon: const Icon(
                        BoxIcons.bx_bell,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "What are you looking for?",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        BoxIcons.bx_search,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        context.read<BookBloc>().add(FetchBooksEvent());
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F1F5),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      context.read<BookBloc>().add(SearchBooksEvent(query));
                    }
                  },
                ),
                const SizedBox(height: 25),

                // Categories Section
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Add this inside the build method where categories are being built
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      String selectedGenre = 'All';
                      if (state is BookLoaded) {
                        selectedGenre = state.selectedGenre;
                      }

                      return Row(
                        children: categories
                            .map((category) => _buildCategoryItem(
                                  context,
                                  category.value,
                                  category.label,
                                  selectedGenre == category.value,
                                ))
                            .toList(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Recent Listings Section
                const Text(
                  "Recent Listings",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Book Listings with One Book Per Row
                BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if (state is BookLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BookLoaded) {
                      if (state.books.isEmpty) {
                        return const Center(child: Text("No books found!"));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.books.length,
                        itemBuilder: (context, index) {
                          final book = state.books[index];
                          return _buildBookCard(
                            context: context, // ✅ Pass context here
                            imageUrl: book.images.isNotEmpty
                                ? 'http://10.0.2.2:5000/api/uploads/books/${book.images.first}'
                                : '',
                            title: book.title,
                            description: book.description,
                            price: book.price,
                            condition: book.condition,
                            postedDate: DateTime.now(),
                            bookId: book.id, // ✅ Pass book ID for navigation
                          );
                        },
                      );
                    } else if (state is BookError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const Center(
                        child: Text("Start by searching a book!"));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Category Item
  Widget _buildCategoryItem(
      BuildContext context, String genre, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        context.read<BookBloc>().add(FilterByGenreEvent(genre));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(color: const Color(0xFFdcdfe6)),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

Widget _buildBookCard({
  required BuildContext context, // Pass BuildContext here
  required String imageUrl,
  required String title,
  required String description,
  required double price,
  required String condition,
  required DateTime postedDate,
  required String bookId, // Pass book ID for navigation
}) {
  final timeAgo = _getTimeAgo(postedDate);

  return GestureDetector(
    onTap: () {
      // ✅ Navigate to Single Book Detail Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailView(bookId: bookId),
        ),
      );
    },
    child: Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Book Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Short Description
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Price and Condition Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rs. ${NumberFormat("#,##0").format(price)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    condition,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Time Posted
            Text(
              timeAgo,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Save Button
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text("Save"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
                // Chat Now Button
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat Now"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper function to display time posted (e.g., "1 month ago")
String _getTimeAgo(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
