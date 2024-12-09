import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String hintText;

  const CustomTextField(
      {required this.validator,
      required this.keyboardType,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 19.0, color: Colors.black),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        filled: true,
        fillColor: const Color.fromARGB(255, 235, 240, 244),
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
