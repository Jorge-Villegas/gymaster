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
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = width ?? constraints.maxWidth * 0.8;
        double buttonHeight = height ?? constraints.maxHeight * 0.1;

        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? colorScheme.primary,
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
                  Icon(icon!.icon, color: textColor ?? colorScheme.onPrimary),
                if (icon != null && text != null) const SizedBox(width: 8),
                if (text != null)
                  Text(
                    text!,
                    style: TextStyle(color: textColor ?? colorScheme.onPrimary),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
