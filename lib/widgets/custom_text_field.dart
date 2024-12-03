import 'package:flutter/material.dart';
import 'package:revive_reads/constants.dart';

class CustomTextField extends StatelessWidget {
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final String hintText;

  const CustomTextField(
      {required this.validator,
      required this.keyboardType,
      required this.prefixIcon,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 19.0, color: Colors.black),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          filled: true,
          fillColor: const Color.fromARGB(255, 241, 246, 251),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 10.0),
            child: Icon(
              prefixIcon,
              color: KPrimaryColor,
              size: 25,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 18.0, color: Colors.black45),
        ),
    );
  }
}
