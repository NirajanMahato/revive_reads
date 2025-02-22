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
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70, // Reduce image quality to save bandwidth
        maxWidth: 1024, // Max width
        maxHeight: 1024, // Max height
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images = pickedFiles.map((file) => File(file.path)).toList();
        });

        // Log picked images
        for (var file in _images) {
          print('Picked image path: ${file.path}');
          print('File exists: ${await file.exists()}');
          print('File size: ${await file.length()} bytes');
        }
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error picking images')),
      );
    }
  }

  void _submitBook() {
    if (_formKey.currentState!.validate()) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post New Book')),
      body: BlocConsumer<PostBookBloc, PostBookState>(
        listener: (context, state) {
          if (state is PostBookSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book Posted Successfully!')));
            Navigator.pop(context);
          } else if (state is PostBookFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is PostBookLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a valid title' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a valid description' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a valid price' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
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
                    decoration: const InputDecoration(labelText: 'Genre'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedCondition,
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
                    decoration: const InputDecoration(labelText: 'Condition'),
                  ),
                  SwitchListTile(
                    value: _delivery,
                    onChanged: (value) => setState(() => _delivery = value),
                    title: const Text('Delivery Available'),
                  ),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text('Upload Images'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitBook,
                    child: const Text('Post Book'),
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
