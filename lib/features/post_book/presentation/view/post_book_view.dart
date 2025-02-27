import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revive_reads/features/post_book/domain/constants/book_constants.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_bloc.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_event.dart';
import 'package:revive_reads/features/post_book/presentation/view_model/post_book_state.dart';

class PostBookView extends StatefulWidget {
  const PostBookView({super.key});

  @override
  _PostBookViewState createState() => _PostBookViewState();
}

class _PostBookViewState extends State<PostBookView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String _selectedGenre = 'Fiction';
  String _selectedCondition = 'Brand New';
  bool _delivery = false;
  final List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error picking images')),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (photo != null) {
        setState(() {
          _images.add(File(photo.path));
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error taking photo')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _submitBook() {
    if (_formKey.currentState!.validate()) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }

      context.read<PostBookBloc>().add(
            SubmitBookEvent(
              title: _titleController.text,
              description: _descriptionController.text,
              price: double.parse(_priceController.text),
              genre: _selectedGenre,
              condition: _selectedCondition,
              images: _images.map((image) => image.path).toList(),
              delivery: _delivery,
            ),
          );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post New Book'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<PostBookBloc, PostBookState>(
        listener: (context, state) {
          if (state is PostBookSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Book Posted Successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is PostBookFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostBookLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Book Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Image Picker Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pickImagesFromGallery,
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[850],
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[200],
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Image Preview Grid
                      if (_images.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _images[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
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
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Book Details Form
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              prefixIcon: const Icon(Icons.book),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter a valid title' : null,
                          ),
                          const SizedBox(height: 16),

                          // Description
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              prefixIcon: const Icon(Icons.description),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                            validator: (value) => value!.isEmpty
                                ? 'Enter a valid description'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Price
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Price',
                              prefixIcon: const Icon(Icons.attach_money),
                              prefixText: 'Rs. ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a valid price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Price must be a number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Genre
                          DropdownButtonFormField<String>(
                            value: _selectedGenre,
                            decoration: InputDecoration(
                              labelText: 'Genre',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: BookConstants.genres
                                .map((genre) => DropdownMenuItem(
                                      value: genre,
                                      child: Text(genre),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGenre = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Condition
                          DropdownButtonFormField<String>(
                            value: _selectedCondition,
                            decoration: InputDecoration(
                              labelText: 'Condition',
                              prefixIcon: const Icon(Icons.star_rate),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: BookConstants.conditions
                                .map((condition) => DropdownMenuItem(
                                      value: condition,
                                      child: Text(condition),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCondition = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // Delivery Option
                          SwitchListTile(
                            value: _delivery,
                            onChanged: (value) =>
                                setState(() => _delivery = value),
                            title: const Text('Delivery Available'),
                            subtitle: Text(
                              _delivery
                                  ? 'You will arrange delivery'
                                  : 'Buyer will pick up',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            secondary: Icon(
                              _delivery ? Icons.local_shipping : Icons.store,
                              color: _delivery ? Colors.blue : Colors.grey,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Post Book',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
