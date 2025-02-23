import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_bloc.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_event.dart';
import 'package:revive_reads/features/my_ads/presentation/view_model/my_ads_state.dart';

class MyAdsView extends StatelessWidget {
  const MyAdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyAdsBloc>()..add(FetchUserBooksEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Books'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<MyAdsBloc, MyAdsState>(
          builder: (context, state) {
            if (state is MyAdsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MyAdsError) {
              return Center(child: Text(state.message));
            }

            if (state is MyAdsLoaded) {
              if (state.books.isEmpty) {
                return const Center(
                  child: Text('You haven\'t posted any books yet'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return _buildMyBookCard(context, book);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMyBookCard(BuildContext context, MyBookEntity book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Book Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                'http://10.0.2.2:5000/api/uploads/books/${book.images.first}',
                width: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),

            // Book Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(book.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _getStatusColor(book.status),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        book.status,
                        style: TextStyle(
                          color: _getStatusColor(book.status),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Text(
                      "Rs. ${NumberFormat("#,##0").format(book.price)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    const Spacer(),

                    // Action Buttons
                    Row(
                      children: [
                        if (!book.sold) ...[
                          // Edit Button
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/edit-book',
                                arguments: book,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 30),
                            ),
                            child: const Text('Edit'),
                          ),
                          const SizedBox(width: 8),

                          // Delete Button
                          OutlinedButton(
                            onPressed: () {
                              _showDeleteConfirmation(context, book.id);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 30),
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Delete'),
                          ),
                          const SizedBox(width: 8),

                          // Mark as Sold Button
                          FilledButton(
                            onPressed: () {
                              context.read<MyAdsBloc>().add(
                                    MarkBookAsSoldEvent(book.id),
                                  );
                            },
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 30),
                            ),
                            child: const Text('Sold'),
                          ),
                        ] else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'SOLD',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MyAdsBloc>().add(DeleteBookEvent(bookId));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
