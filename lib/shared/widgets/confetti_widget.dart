import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Widget de confeti para celebraciones de logros en GyMaster
/// Implementa efectos de partículas coloridas para feedback emocional positivo
class ConfettiWidget extends StatefulWidget {
  final bool iniciarAutomaticamente;

  /// Duración de la animación de confeti
  final Duration duracionAnimacionConfeti;

  /// Cantidad de partículas de confeti
  final int cantidadParticulasConfeti;

  /// Colores de las partículas
  final List<Color> coloresParticulasConfeti;

  /// Si las partículas deben caer desde arriba
  final bool particulasCaenDesdeArriba;

  /// Tamaño de las partículas
  final double tamanoParticulaConfeti;

  /// Velocidad de las partículas
  final double velocidadParticulaConfeti;

  /// Callback cuando termina la animación
  final VoidCallback? onComplete;

  const ConfettiWidget({
    super.key,
    this.iniciarAutomaticamente = true,
    this.duracionAnimacionConfeti = const Duration(seconds: 3),
    this.cantidadParticulasConfeti = 50,
    this.coloresParticulasConfeti = const [
      // Usando colores HSB más suaves del sistema
      Color(0xFF4CAF50), // Verde natural
      Color(0xFF2196F3), // Azul cálido
      Color(0xFFFFC107), // Dorado suave
      Color(0xFF9C27B0), // Púrpura equilibrado
      Color(0xFFFF9800), // Naranja cálido
      Color(0xFF00BCD4), // Turquesa
      Color(0xFFE91E63), // Rosa coral
    ],
    this.particulasCaenDesdeArriba = true,
    this.tamanoParticulaConfeti = 8.0,
    this.velocidadParticulaConfeti = 100.0,
    this.onComplete,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with TickerProviderStateMixin {
  late AnimationController _controladorAnimacionConfeti;
  late List<ConfettiParticle> _particulasConfeti;
  late Random _generadorAleatorio;

  @override
  void initState() {
    super.initState();
    _generadorAleatorio = Random();
    _controladorAnimacionConfeti = AnimationController(
      duration: widget.duracionAnimacionConfeti,
      vsync: this,
    );

    _inicializarParticulasConfeti();

    if (widget.iniciarAutomaticamente) {
      iniciarAnimacionConfeti();
    }

    _controladorAnimacionConfeti.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controladorAnimacionConfeti.dispose();
    super.dispose();
  }

  void iniciarAnimacionConfeti() {
    _controladorAnimacionConfeti.forward();
  }

  void detenerAnimacionConfeti() {
    _controladorAnimacionConfeti.stop();
  }

  void reiniciarAnimacionYParticulasConfeti() {
    _controladorAnimacionConfeti.reset();
    _inicializarParticulasConfeti();
  }

  void _inicializarParticulasConfeti() {
    _particulasConfeti =
        List.generate(widget.cantidadParticulasConfeti, (index) {
      return ConfettiParticle(
        x: _generadorAleatorio.nextDouble(),
        y: widget.particulasCaenDesdeArriba
            ? -0.1
            : _generadorAleatorio.nextDouble(),
        color: widget.coloresParticulasConfeti[_generadorAleatorio
            .nextInt(widget.coloresParticulasConfeti.length)],
        tamanio: widget.tamanoParticulaConfeti +
            (_generadorAleatorio.nextDouble() * 4),
        velocidad: widget.velocidadParticulaConfeti +
            (_generadorAleatorio.nextDouble() * 50),
        rotacion: _generadorAleatorio.nextDouble() * 2 * pi,
        velocidadRotacion: (_generadorAleatorio.nextDouble() - 0.5) * 10,
        forma: FormaConfeti
            .values[_generadorAleatorio.nextInt(FormaConfeti.values.length)],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controladorAnimacionConfeti,
      builder: (context, child) {
        return CustomPaint(
          painter: PintorConfeti(
            particulasConfeti: _particulasConfeti,
            progresoAnimacionConfeti: _controladorAnimacionConfeti.value,
            particulasCaenDesdeArriba: widget.particulasCaenDesdeArriba,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class PintorConfeti extends CustomPainter {
  final List<ConfettiParticle> particulasConfeti;
  final double progresoAnimacionConfeti;
  final bool particulasCaenDesdeArriba;

  PintorConfeti({
    required this.particulasConfeti,
    required this.progresoAnimacionConfeti,
    required this.particulasCaenDesdeArriba,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particulasConfeti) {
      _paintParticle(canvas, size, particle);
    }
  }

  void _paintParticle(Canvas canvas, Size size, ConfettiParticle particle) {
    final paint = Paint()
      ..color = particle.color.withAlpha(
          ((1.0 - (progresoAnimacionConfeti * 0.3)) * 255)
              .clamp(0, 255)
              .toInt());

    // Calcular posición basada en el progreso
    double x = particle.x * size.width;
    double y;

    if (particulasCaenDesdeArriba) {
      y = (particle.y * size.height) +
          (progresoAnimacionConfeti * particle.velocidad * 3);
    } else {
      y = particle.y * size.height;
    }

    // Aplicar movimiento de gravedad y viento
    y += progresoAnimacionConfeti * progresoAnimacionConfeti * 50; // Gravedad
    x += sin(progresoAnimacionConfeti * 10 + particle.rotacion) *
        20; // Movimiento de viento

    // Rotación de la partícula
    final rotation = particle.rotacion +
        (progresoAnimacionConfeti * particle.velocidadRotacion);

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);

    // Dibujar según la forma
    switch (particle.forma) {
      case FormaConfeti.circulo:
        canvas.drawCircle(
          Offset.zero,
          particle.tamanio / 2,
          paint,
        );
        break;
      case FormaConfeti.cuadrado:
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particle.tamanio,
            height: particle.tamanio,
          ),
          paint,
        );
        break;
      case FormaConfeti.triangulo:
        _drawTriangle(canvas, particle.tamanio, paint);
        break;
      case FormaConfeti.estrella:
        _dibujarEstrellaConfeti(canvas, particle.tamanio, paint);
        break;
    }

    canvas.restore();
  }

  void _drawTriangle(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, -size / 2);
    path.lineTo(-size / 2, size / 2);
    path.lineTo(size / 2, size / 2);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _dibujarEstrellaConfeti(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final radioExterior = size / 2;
    final radioInterior = radioExterior * 0.4;

    for (int i = 0; i < 5; i++) {
      final anguloExterior = (i * 2 * pi / 5) - (pi / 2);
      final anguloInterior = anguloExterior + (pi / 5);

      if (i == 0) {
        path.moveTo(
          radioExterior * cos(anguloExterior),
          radioExterior * sin(anguloExterior),
        );
      } else {
        path.lineTo(
          radioExterior * cos(anguloExterior),
          radioExterior * sin(anguloExterior),
        );
      }

      path.lineTo(
        radioInterior * cos(anguloInterior),
        radioInterior * sin(anguloInterior),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double tamanio;
  final double velocidad;
  final double rotacion;
  final double velocidadRotacion;
  final FormaConfeti forma;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.tamanio,
    required this.velocidad,
    required this.rotacion,
    required this.velocidadRotacion,
    required this.forma,
  });
}

enum FormaConfeti {
  circulo,
  cuadrado,
  triangulo,
  estrella,
}

/// Widget de celebración con confeti para logros específicos del gimnasio
class CelebracionConfeti extends StatelessWidget {
  final TipoCelebracion tipoCelebracion;
  final bool iniciarAutomaticamente;
  final VoidCallback? alCompletarCelebracion;

  const CelebracionConfeti({
    super.key,
    required this.tipoCelebracion,
    this.iniciarAutomaticamente = true,
    this.alCompletarCelebracion,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      iniciarAutomaticamente: iniciarAutomaticamente,
      duracionAnimacionConfeti:
          _obtenerDuracionAnimacionConfetiPorTipo(tipoCelebracion),
      cantidadParticulasConfeti:
          _obtenerCantidadParticulasConfetiPorTipo(tipoCelebracion),
      coloresParticulasConfeti:
          _obtenerColoresParticulasConfetiPorTipo(tipoCelebracion),
      tamanoParticulaConfeti:
          _obtenerTamanoParticulaConfetiPorTipo(tipoCelebracion),
      velocidadParticulaConfeti:
          _obtenerVelocidadParticulaConfetiPorTipo(tipoCelebracion),
      onComplete: alCompletarCelebracion,
    );
  }

  Duration _obtenerDuracionAnimacionConfetiPorTipo(TipoCelebracion tipo) {
    switch (tipo) {
      case TipoCelebracion.rutinaCompletada:
        return const Duration(seconds: 3);
      case TipoCelebracion.recordPersonal:
        return const Duration(seconds: 4);
      case TipoCelebracion.metaSemanal:
        return const Duration(seconds: 3);
      case TipoCelebracion.logroMensual:
        return const Duration(seconds: 5);
      case TipoCelebracion.subidaDeNivel:
        return const Duration(seconds: 4);
    }
  }

  int _obtenerCantidadParticulasConfetiPorTipo(TipoCelebracion tipo) {
    switch (tipo) {
      case TipoCelebracion.rutinaCompletada:
        return 30;
      case TipoCelebracion.recordPersonal:
        return 60;
      case TipoCelebracion.metaSemanal:
        return 40;
      case TipoCelebracion.logroMensual:
        return 80;
      case TipoCelebracion.subidaDeNivel:
        return 70;
    }
  }

  List<Color> _obtenerColoresParticulasConfetiPorTipo(TipoCelebracion tipo) {
    switch (tipo) {
      case TipoCelebracion.rutinaCompletada:
        return [Colors.green, Colors.lightGreen, Colors.teal];
      case TipoCelebracion.recordPersonal:
        return [AppColors.acento, AppColors.acentoCalido, AppColors.acento];
      case TipoCelebracion.metaSemanal:
        return [Colors.blue, Colors.lightBlue, Colors.cyan];
      case TipoCelebracion.logroMensual:
        return [Colors.purple, Colors.deepPurple, Colors.indigo];
      case TipoCelebracion.subidaDeNivel:
        return [
          AppColors.primarioCalido,
          AppColors.acento,
          AppColors.acentoCalido
        ];
    }
  }

  double _obtenerTamanoParticulaConfetiPorTipo(TipoCelebracion tipo) {
    switch (tipo) {
      case TipoCelebracion.rutinaCompletada:
        return 6.0;
      case TipoCelebracion.recordPersonal:
        return 10.0;
      case TipoCelebracion.metaSemanal:
        return 7.0;
      case TipoCelebracion.logroMensual:
        return 12.0;
      case TipoCelebracion.subidaDeNivel:
        return 9.0;
    }
  }

  double _obtenerVelocidadParticulaConfetiPorTipo(TipoCelebracion tipo) {
    switch (tipo) {
      case TipoCelebracion.rutinaCompletada:
        return 80.0;
      case TipoCelebracion.recordPersonal:
        return 120.0;
      case TipoCelebracion.metaSemanal:
        return 90.0;
      case TipoCelebracion.logroMensual:
        return 140.0;
      case TipoCelebracion.subidaDeNivel:
        return 110.0;
    }
  }
}

enum TipoCelebracion {
  rutinaCompletada,
  recordPersonal,
  metaSemanal,
  logroMensual,
  subidaDeNivel,
}
