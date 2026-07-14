import 'package:flutter/material.dart';

/// Estado de ánimo de la mascota. Es un disparador emocional de retención:
/// una rata feliz refuerza el hábito y una preocupada/triste activa la culpa
/// cariñosa que hace volver (mismo principio que el "Duo enfermo").
enum RatMood {
  /// Entrenaste hoy y la racha vive. 😄
  feliz,

  /// Aún no entrenas hoy y la racha está en riesgo. 😟
  preocupada,

  /// La racha se rompió. 😴
  triste,

  /// Subiste de nivel / desbloqueaste un logro. 🎉
  celebrando,
}

/// Mascota — Rata de gym 🐀 (placeholder pintado con [CustomPaint]).
///
/// Cambia de expresión según [mood] (ojos, boca y detalles). Es un placeholder
/// funcional; el diseño final será una ilustración / Lottie con los mismos
/// estados. Se dimensiona según el padre (envolver en un `SizedBox` o pasar
/// [size]).
class RatMascot extends StatelessWidget {
  final double? size;
  final RatMood mood;

  const RatMascot({super.key, this.size, this.mood = RatMood.feliz});

  @override
  Widget build(BuildContext context) {
    final child = CustomPaint(painter: _RatPainter(mood), size: Size.infinite);
    if (size == null) return child;
    return SizedBox(width: size, height: size, child: child);
  }
}

class _RatPainter extends CustomPainter {
  final RatMood mood;
  _RatPainter(this.mood);

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

    final triste = mood == RatMood.triste;
    final preocupada = mood == RatMood.preocupada;
    final celebrando = mood == RatMood.celebrando;

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

    // Orejas (caídas si está triste)
    final oyL = triste ? 40.0 : 34.0;
    final oyR = triste ? 40.0 : 34.0;
    canvas.drawCircle(p(34, oyL), r(16), ear);
    canvas.drawCircle(p(34, oyL), r(8), pink);
    canvas.drawCircle(p(86, oyR), r(16), ear);
    canvas.drawCircle(p(86, oyR), r(8), pink);

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

    // Ojos según ánimo
    if (triste) {
      // Ojos entrecerrados (arcos hacia abajo).
      final ojo = Paint()
        ..color = const Color(0xFF20303A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r(3)
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
          Rect.fromCenter(center: p(49, 66), width: r(12), height: r(10)),
          3.6, 2.1, false, ojo);
      canvas.drawArc(
          Rect.fromCenter(center: p(71, 66), width: r(12), height: r(10)),
          3.6, 2.1, false, ojo);
    } else {
      canvas.drawCircle(p(49, 64), r(6), dark);
      canvas.drawCircle(p(71, 64), r(6), dark);
      canvas.drawCircle(p(51, 62), r(2), white);
      canvas.drawCircle(p(73, 62), r(2), white);
    }

    // Cejas preocupadas (inclinadas hacia el centro).
    if (preocupada) {
      final ceja = Paint()
        ..color = const Color(0xFF20303A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r(2.4)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(p(43, 55), p(53, 58), ceja);
      canvas.drawLine(p(77, 55), p(67, 58), ceja);
    }

    // Hocico
    canvas.drawOval(
        Rect.fromCenter(center: p(60, 80), width: r(12), height: r(10)), snout);

    // Boca según ánimo
    final boca = Paint()
      ..color = const Color(0xFF20303A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r(2.4)
      ..strokeCap = StrokeCap.round;
    if (celebrando) {
      // Sonrisa abierta (boca rellena).
      final sonrisa = Path()
        ..moveTo(p(52, 89).dx, p(52, 89).dy)
        ..quadraticBezierTo(p(60, 99).dx, p(60, 99).dy, p(68, 89).dx, p(68, 89).dy)
        ..close();
      canvas.drawPath(sonrisa, coralInk);
    } else if (triste) {
      // Boca hacia abajo.
      final frown = Path()
        ..moveTo(p(53, 92).dx, p(53, 92).dy)
        ..quadraticBezierTo(p(60, 87).dx, p(60, 87).dy, p(67, 92).dx, p(67, 92).dy);
      canvas.drawPath(frown, boca);
    } else if (preocupada) {
      // Boca pequeña ondulada (nerviosa).
      final nerv = Path()
        ..moveTo(p(54, 90).dx, p(54, 90).dy)
        ..quadraticBezierTo(p(57, 88).dx, p(57, 88).dy, p(60, 90).dx, p(60, 90).dy)
        ..quadraticBezierTo(p(63, 92).dx, p(63, 92).dy, p(66, 90).dx, p(66, 90).dy);
      canvas.drawPath(nerv, boca);
    } else {
      // Sonrisa suave (feliz).
      final sonrisa = Path()
        ..moveTo(p(53, 89).dx, p(53, 89).dy)
        ..quadraticBezierTo(p(60, 94).dx, p(60, 94).dy, p(67, 89).dx, p(67, 89).dy);
      canvas.drawPath(sonrisa, boca);
    }

    // Bigotes
    final wh = Paint()
      ..color = const Color(0xFFB9C0C8)
      ..strokeWidth = r(1.4)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p(40, 82), p(22, 82), wh);
    canvas.drawLine(p(40, 86), p(24, 86), wh);
    canvas.drawLine(p(80, 82), p(98, 82), wh);
    canvas.drawLine(p(80, 86), p(96, 86), wh);

    // Gota de sudor si está preocupada.
    if (preocupada) {
      final gota = Path()
        ..moveTo(p(88, 54).dx, p(88, 54).dy)
        ..quadraticBezierTo(p(93, 60).dx, p(93, 60).dy, p(88, 63).dx, p(88, 63).dy)
        ..quadraticBezierTo(p(83, 60).dx, p(83, 60).dy, p(88, 54).dx, p(88, 54).dy)
        ..close();
      canvas.drawPath(gota, Paint()..color = const Color(0xFF54BEFF));
    }

    // Destellos si celebra.
    if (celebrando) {
      final chispa = Paint()..color = const Color(0xFFFFC531);
      void estrella(Offset ctr, double rad) {
        canvas.drawCircle(ctr, rad, chispa);
      }
      estrella(p(24, 30), r(3.5));
      estrella(p(98, 32), r(3));
      estrella(p(16, 60), r(2.5));
    }

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
  bool shouldRepaint(covariant _RatPainter oldDelegate) =>
      oldDelegate.mood != mood;
}
