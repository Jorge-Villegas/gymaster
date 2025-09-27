import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';

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
        labelStyle: TipografiaGyMaster.textoSecundario,
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
