import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String placeholder;
  final int maxlines;
  final int minlines;

  const CustomTextfield({
    super.key,
    required this.placeholder,
    required this.maxlines,
    required this.minlines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxlines,
      minLines: minlines,
      style: const TextStyle(color: Colors.white), // Set text color to white
      decoration: InputDecoration(
        filled: false, // Disable filling to make the background transparent
        hintText: placeholder,
        hintStyle: const TextStyle(color: Colors.grey), // Hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0), // Rounded corners
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5), // Border color with transparency
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.white), // Border color when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5), // Border color when enabled
          ),
        ),
      ),
    );
  }
}
