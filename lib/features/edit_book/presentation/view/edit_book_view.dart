import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_bloc.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_event.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_state.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';

class EditBookView extends StatefulWidget {
  final MyBookEntity book;

  const EditBookView({super.key, required this.book});

  @override
  State<EditBookView> createState() => _EditBookViewState();
}

class _EditBookViewState extends State<EditBookView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String _selectedGenre;
  late String _selectedCondition;
  late bool _delivery;
  List<File> _newImages = [];
  late List<String> _existingImages;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _descriptionController =
        TextEditingController(text: widget.book.description);
    _priceController =
        TextEditingController(text: widget.book.price.toString());
    _selectedGenre = widget.book.genre;
    _selectedCondition = widget.book.condition;
    _delivery = widget.book.delivery;
    _existingImages = List.from(widget.book.images);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _newImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      context.read<EditBookBloc>().add(
            UpdateBookEvent(
              bookId: widget.book.id,
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              genre: _selectedGenre,
              condition: _selectedCondition,
              delivery: _delivery,
              newImages: _newImages.map((image) => image.path).toList(),
              existingImages: _existingImages,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EditBookBloc>(),
      child: BlocConsumer<EditBookBloc, EditBookState>(
        listener: (context, state) {
          if (state is EditBookSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Book updated successfully!')),
            );
            // Navigate back with a success result
            Navigator.pop(context, true);
          } else if (state is EditBookFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Book'),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
            body: state is EditBookLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Images
                          const Text(
                            'Book Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Existing Images
                          if (_existingImages.isNotEmpty) ...[
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _existingImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            'http://10.0.2.2:5000/api/uploads/books/${_existingImages[index]}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () =>
                                              _removeExistingImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // New Images
                          if (_newImages.isNotEmpty) ...[
                            const Text(
                              'New Images',
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _newImages.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _newImages[index],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () => _removeNewImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Add Images Button
                          ElevatedButton.icon(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Images'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Form Fields
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Title is required' : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) => value!.isEmpty
                                ? 'Description is required'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(),
                              prefixText: 'Rs. ',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Price is required';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Invalid price format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Genre Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedGenre,
                            decoration: const InputDecoration(
                              labelText: 'Genre',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Fiction',
                                child: Text('Fiction'),
                              ),
                              DropdownMenuItem(
                                value: 'Non Fiction & Biography',
                                child: Text('Non Fiction & Biography'),
                              ),
                              DropdownMenuItem(
                                value: 'Technology',
                                child: Text('Technology'),
                              ),
                              // Add other genres from your constants
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGenre = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Condition Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedCondition,
                            decoration: const InputDecoration(
                              labelText: 'Condition',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Brand New',
                                child: Text('Brand New'),
                              ),
                              DropdownMenuItem(
                                value: 'Like New',
                                child: Text('Like New'),
                              ),
                              DropdownMenuItem(
                                value: 'Used',
                                child: Text('Used'),
                              ),
                              DropdownMenuItem(
                                value: 'Acceptable',
                                child: Text('Acceptable'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCondition = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Delivery Switch
                          SwitchListTile(
                            title: const Text('Delivery Available'),
                            value: _delivery,
                            onChanged: (value) {
                              setState(() {
                                _delivery = value;
                              });
                            },
                            tileColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitUpdate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Update Book',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
