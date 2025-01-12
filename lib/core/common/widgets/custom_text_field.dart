import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String hintText;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.validator,
      required this.keyboardType,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 19.0, color: Colors.black),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        filled: true,
        fillColor: const Color.fromARGB(255, 244, 246, 247),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black),
        ),
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 18.0, color: Colors.black45),
      ),
    );
  }
}
