import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Icon? icon;

  const CustomElevatedButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xFF675BE0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (icon != null && text != null) const SizedBox(width: 8),
          if (text != null)
            Text(
              text!,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
        ],
      ),
    );
  }
}