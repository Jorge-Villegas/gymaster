import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Icon? icon;
  final double? width;
  final double? height;
  final double? borderRadius;

  const CustomElevatedButton({
    super.key,
    this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 40,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = width ?? constraints.maxWidth * 0.8;
        double buttonHeight = height ?? constraints.maxHeight * 0.1;

        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? const Color(0xFF675BE0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Icon(icon!.icon, color: textColor ?? Colors.white),
                if (icon != null && text != null) const SizedBox(width: 8),
                if (text != null)
                  Text(
                    text!,
                    style: TextStyle(color: textColor ?? Colors.white),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
