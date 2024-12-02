import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String placeholder;
  final int maxlines;
  final int minlines;
  const CustomTextfield(
      {super.key,
      required this.placeholder,
      required this.maxlines,
      required this.minlines});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxlines,
      minLines: minlines,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF403B4D),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none),
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.grey)),
    );
  }
}
