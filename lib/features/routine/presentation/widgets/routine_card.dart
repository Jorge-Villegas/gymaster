import 'package:gymaster/core/utils/text_formatter.dart';
import 'package:flutter/material.dart';
class RoutineCard extends StatelessWidget {
  final Function onTap;
  final String cantidadEjerciciosPorSeries;
  final String title;
  final int color;

  const RoutineCard({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.cantidadEjerciciosPorSeries,
  });

  @override
  Widget build(BuildContext context) {
    Color colorTitle = Colors.black;
    Color colorSubtitle = Colors.black45;

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Color(color),
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Color.lerp(Color(color), Colors.black, 0.2)!,
        //     Color.lerp(Color(color), Colors.black, 0.2)!,
        //   ],
        // ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: _PinkBox(color: Color(color)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(20),
            title: Text(
              TextFormatter.capitalize(title),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorTitle,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                cantidadEjerciciosPorSeries,
                style: TextStyle(
                  fontSize: 15,
                  color: colorSubtitle,
                ),
              ),
            ),
            onTap: () => onTap(),
          ),
        ],
      ),
    );
  }
}

class _PinkBox extends StatelessWidget {
  final Color color;

  const _PinkBox({
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double size = 110;
    return Transform.rotate(
      angle: 0.5,
      child: Container(
        width: size * 1.618033988,
        height: size * 1.618033988,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.75),
              Colors.white.withOpacity(0.5),
            ],
          ),
        ),
      ),
    );
  }
}
