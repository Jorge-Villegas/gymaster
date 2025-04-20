import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymaster/shared/utils/text_formatter.dart';

class RoutineCard extends StatelessWidget {
  final VoidCallback onTap;
  final String cantidadEjerciciosPorSeries;
  final String title;
  final int color;
  final String? imagenDireccion;

  const RoutineCard({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.cantidadEjerciciosPorSeries,
    this.imagenDireccion,
  });

  @override
  Widget build(BuildContext context) {
    const Color colorTitle = Colors.black;
    const Color colorSubtitle = Colors.black45;

    return GestureDetector(
      onTap: () => onTap(),
      child: Stack(
        children: <Widget>[
          _BotonGordoBackground(
            imagenDireccion ?? 'assets/default.svg',
            Color(color),
            Color(color),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextFormatter.capitalize(title),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorTitle,
                    ),
                  ),
                  Text(
                    cantidadEjerciciosPorSeries,
                    style: const TextStyle(color: colorSubtitle, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonGordoBackground extends StatelessWidget {
  final String imagenDireccion;
  final Color color1;
  final Color color2;

  const _BotonGordoBackground(this.imagenDireccion, this.color1, this.color2);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color1, color2]),
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: SvgPicture.asset(
              imagenDireccion,
              width: 150,
              height: 150,
              colorFilter: ColorFilter.mode(
                color1.withAlpha((0.75 * 255).toInt()),
                BlendMode.srcATop,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    offset: const Offset(4, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
