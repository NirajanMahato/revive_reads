import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_bloc.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_event.dart';
import 'package:revive_reads/features/edit_book/presentation/view_model/edit_book_state.dart';
import 'package:revive_reads/features/my_ads/domain/entity/my_book_entity.dart';
import 'package:revive_reads/features/post_book/domain/constants/book_constants.dart';

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
  final List<File> _newImages = [];
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

  Future<void> _pickImagesFromGallery() async {
    try {
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _newImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
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
          _newImages.add(File(photo.path));
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error taking photo')),
      );
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
              SnackBar(
                content: const Text('Book updated successfully!'),
                backgroundColor: Colors.grey[800],
              ),
            );
            Navigator.pop(context, true);
          } else if (state is EditBookFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.grey[700],
              ),
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
                          // Book Images Section
                          const Text(
                            'Book Images',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Camera and Gallery Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _pickImagesFromGallery,
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Gallery'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[700],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
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
                                    backgroundColor: Colors.grey[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Existing Images
                          if (_existingImages.isNotEmpty) ...[
                            const Text(
                              'Current Images',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                                            decoration: BoxDecoration(
                                              color: Colors.grey[850],
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
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
                                            decoration: BoxDecoration(
                                              color: Colors.grey[850],
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

                          const SizedBox(height: 24),

                          // Book Details Card
                          Card(
                            elevation: 2,
                            color: Colors.grey[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Book Details',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Form Fields
                                  TextFormField(
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      prefixIcon: Icon(Icons.book,
                                          color: Colors.grey[600]),
                                    ),
                                    validator: (value) => value!.isEmpty
                                        ? 'Title is required'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      prefixIcon: Icon(Icons.description,
                                          color: Colors.grey[600]),
                                      alignLabelWithHint: true,
                                    ),
                                    maxLines: 3,
                                    validator: (value) => value!.isEmpty
                                        ? 'Description is required'
                                        : null,
                                  ),
                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _priceController,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      prefixIcon: Icon(Icons.attach_money,
                                          color: Colors.grey[600]),
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

                                  // Genre Dropdown - Using Book Constants
                                  DropdownButtonFormField<String>(
                                    value: _selectedGenre,
                                    decoration: InputDecoration(
                                      labelText: 'Genre',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      prefixIcon: Icon(Icons.category,
                                          color: Colors.grey[600]),
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

                                  // Condition Dropdown - Using Book Constants
                                  DropdownButtonFormField<String>(
                                    value: _selectedCondition,
                                    decoration: InputDecoration(
                                      labelText: 'Condition',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                            color: Colors.grey[300]!),
                                      ),
                                      prefixIcon: Icon(Icons.star_rate,
                                          color: Colors.grey[600]),
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

                                  // Delivery Switch
                                  SwitchListTile(
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
                                    value: _delivery,
                                    onChanged: (value) {
                                      setState(() {
                                        _delivery = value;
                                      });
                                    },
                                    secondary: Icon(
                                      _delivery
                                          ? Icons.local_shipping
                                          : Icons.store,
                                      color: _delivery
                                          ? Colors.grey[800]
                                          : Colors.grey[400],
                                    ),
                                    tileColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side:
                                          BorderSide(color: Colors.grey[300]!),
                                    ),
                                    activeColor: Colors.grey[800],
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
                              onPressed: _submitUpdate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[850],
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Update Book',
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
                  ),
          );
        },
      ),
    );
  }
}
