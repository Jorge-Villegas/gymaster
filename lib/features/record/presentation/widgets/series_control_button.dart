import 'package:flutter/material.dart';

class SeriesControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SeriesControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromRGBO(232, 238, 241, 1.0),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
