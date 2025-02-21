import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_bloc.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_event.dart';
import 'package:revive_reads/features/dashboard/presentation/view_model/book_state.dart';

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryItem("${Emojis.openBook} Fiction"),
                      _buildCategoryItem("${Emojis.books} Non-Fiction"),
                      _buildCategoryItem("${Emojis.sparkles} Fantasy"),
                      _buildCategoryItem("${Emojis.lightBulb} Mystery"),
                      _buildCategoryItem("${Emojis.rocket} Science Fiction"),
                      _buildCategoryItem("${Emojis.memo} Biography"),
                      _buildCategoryItem("${Emojis.scroll} History"),
                    ],
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
                          return _buildListingItem(
                            book.title,
                            book.description,
                            book.images.isNotEmpty
                                ? 'http://10.0.2.2:5000/api/uploads/books/${book.images.first}'
                                : null,
                            book.genre,
                            book.price,
                            book.condition,
                            DateTime.now(),
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
  Widget _buildCategoryItem(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Poppins Medium',
        ),
      ),
    );
  }

  // Single Book Listing Item with details
  Widget _buildListingItem(
    String title,
    String description,
    String? imageUrl,
    String genre,
    double price,
    String condition,
    DateTime approvalDate,
  ) {
    final daysAgo = DateTime.now().difference(approvalDate).inDays;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover and Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 90,
                          height: 130,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 90,
                          height: 130,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book, color: Colors.grey),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text("Price: Rs. ${price.toStringAsFixed(2)}"),
                      Text("Condition: $condition"),
                      Text("Posted: $daysAgo days ago"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Save the book
                  },
                  icon: const Icon(Icons.bookmark_border),
                  label: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Start chat
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
