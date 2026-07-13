import 'package:flutter/material.dart';

/// Mascota — Rata de gym 🐀 (placeholder pintado con [CustomPaint]).
///
/// Es un placeholder funcional; el diseño final será una ilustración / Lottie
/// con estados (idle, celebrar, triste por racha rota, dormir). Se dimensiona
/// según el padre (envolver en un `SizedBox`).
class RatMascot extends StatelessWidget {
  final double? size;
  const RatMascot({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final child = CustomPaint(painter: _RatPainter(), size: Size.infinite);
    if (size == null) return child;
    return SizedBox(width: size, height: size, child: child);
  }
}

class _RatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 120.0; // viewBox 120x120
    Offset p(double x, double y) => Offset(x * s, y * s);
    double r(double v) => v * s;

    final body = Paint()..color = const Color(0xFFD5DBE1);
    final ear = Paint()..color = const Color(0xFFC9CFD6);
    final pink = Paint()..color = const Color(0xFFF3B7C6);
    final face = Paint()..color = const Color(0xFFEDEFF2);
    final dark = Paint()..color = const Color(0xFF20303A);
    final white = Paint()..color = Colors.white;
    final coral = Paint()..color = const Color(0xFFFF6B4A);
    final coralInk = Paint()..color = const Color(0xFFE0492B);
    final snout = Paint()..color = const Color(0xFFF3849B);
    final metal = Paint()..color = const Color(0xFF4B5A64);
    final metalDark = Paint()..color = const Color(0xFF3A4750);

    // Sombra en el piso
    canvas.drawOval(
        Rect.fromCenter(center: p(60, 112), width: r(60), height: r(12)),
        Paint()..color = Colors.black.withValues(alpha: .15));

    // Cola
    final tail = Path()
      ..moveTo(p(92, 78).dx, p(92, 78).dy)
      ..quadraticBezierTo(
          p(118, 76).dx, p(118, 76).dy, p(116, 52).dx, p(116, 52).dy);
    canvas.drawPath(
        tail,
        Paint()
          ..color = const Color(0xFFC9CFD6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = r(7)
          ..strokeCap = StrokeCap.round);

    // Orejas
    canvas.drawCircle(p(34, 34), r(16), ear);
    canvas.drawCircle(p(34, 34), r(8), pink);
    canvas.drawCircle(p(86, 34), r(16), ear);
    canvas.drawCircle(p(86, 34), r(8), pink);

    // Cuerpo
    canvas.drawOval(
        Rect.fromCenter(center: p(60, 66), width: r(68), height: r(66)), body);

    // Vincha
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(p(26, 40).dx, p(26, 40).dy, r(68), r(12)),
            Radius.circular(r(6))),
        coral);
    canvas.drawRect(
        Rect.fromLTWH(p(55, 40).dx, p(55, 40).dy, r(10), r(12)), coralInk);

    // Cara
    canvas.drawOval(
        Rect.fromCenter(center: p(60, 78), width: r(40), height: r(32)), face);

    // Ojos
    canvas.drawCircle(p(49, 64), r(6), dark);
    canvas.drawCircle(p(71, 64), r(6), dark);
    canvas.drawCircle(p(51, 62), r(2), white);
    canvas.drawCircle(p(73, 62), r(2), white);

    // Hocico
    canvas.drawOval(
        Rect.fromCenter(center: p(60, 80), width: r(12), height: r(10)), snout);

    // Bigotes
    final wh = Paint()
      ..color = const Color(0xFFB9C0C8)
      ..strokeWidth = r(1.4)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p(40, 82), p(22, 82), wh);
    canvas.drawLine(p(40, 86), p(24, 86), wh);
    canvas.drawLine(p(80, 82), p(98, 82), wh);
    canvas.drawLine(p(80, 86), p(96, 86), wh);

    // Mancuernas
    void dumbbell(double dx) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(p(dx, 96).dx, p(dx, 96).dy, r(4), r(10)),
              Radius.circular(r(1.5))),
          metalDark);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(p(dx + 4, 98).dx, p(dx + 4, 98).dy, r(14), r(6)),
              Radius.circular(r(2))),
          metal);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(p(dx + 18, 96).dx, p(dx + 18, 96).dy, r(4), r(10)),
              Radius.circular(r(1.5))),
          metalDark);
    }

    dumbbell(20);
    dumbbell(78);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
