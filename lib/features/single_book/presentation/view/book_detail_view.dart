import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/core/utils/gyroscope_tilt_view.dart';
import 'package:revive_reads/features/single_book/presentation/view_model/book_detail_bloc.dart';

class BookDetailView extends StatelessWidget {
  final String bookId;

  const BookDetailView({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    // Trigger fetching book details
    context.read<BookDetailBloc>().add(FetchBookDetailEvent(bookId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: BlocBuilder<BookDetailBloc, BookDetailState>(
        builder: (context, state) {
          if (state is BookDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailLoaded) {
            final book = state.bookDetail;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GyroscopeTiltView(
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            'http://10.0.2.2:5000/api/uploads/books/${book.images.first}',
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Book Title
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Genre
                  Text(
                    "Genre: ${book.genre}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Description
                  Text(
                    book.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),

                  // Price and Condition
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs. ${book.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book.condition,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Seller Details
                  const Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'http://10.0.2.2:5000/api/uploads/users/${book.sellerAvatar}',
                      ),
                      radius: 30,
                    ),
                    title: Text(book.sellerName),
                    subtitle: Text(book.sellerEmail),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Location: ${book.sellerAddress}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Save functionality
                          },
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Chat functionality
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Chat Now"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is BookDetailError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No details available"));
          }
        },
      ),
    );
  }
}
