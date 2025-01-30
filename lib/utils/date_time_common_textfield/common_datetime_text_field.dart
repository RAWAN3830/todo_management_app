import 'package:flutter/material.dart';

class CommonDateTimeTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final Widget? suffixIcon;

  const CommonDateTimeTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
           suffixIcon: suffixIcon,
            hintText: hintText,
            labelStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}