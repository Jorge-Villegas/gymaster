import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String text;
  final String? labelText;
  final String? helperText;

  const CustomInputField({
    super.key,
    required this.text,
    this.helperText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
        labelStyle: const TextStyle(
          fontSize: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$text es requerido';
        }
        return null;
      },
    );
  }
}
