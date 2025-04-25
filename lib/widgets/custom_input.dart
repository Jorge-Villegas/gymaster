import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Function(String) onSubmitted;
  final Function(String) onChanged;
  final Color backgroundColor;
  final double borderRadius;
  final double width;
  final double height;
  final IconData? icon;
  final Color focusedColor;
  final bool isPassword;
  final Color borderColor;
  final Color textColor;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;

  const CustomInput({
    super.key,
    this.textColor = Colors.black,
    required this.borderColor,
    required this.controller,
    required this.label,
    this.obscureText = false,
    required this.onSubmitted,
    required this.onChanged,
    this.backgroundColor = const Color.fromRGBO(157, 168, 188, 0.4),
    this.borderRadius = 10,
    this.width = double.infinity,
    this.height = 50.0,
    this.icon = Icons.person,
    this.focusedColor = Colors.red,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLength = 25,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(
          maxLength,
        ),
      ],
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        suffixIcon: suffixIcon,
        hintText: label,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54, // color del icono
        ),
        fillColor: const Color.fromRGBO(255, 255, 255, 0.2),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(0, 175, 26, 26),
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
