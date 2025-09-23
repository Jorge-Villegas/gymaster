import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/shared/utils/haptic_feedback_helper.dart';

class ChicletButton extends StatefulWidget {
  final String texto;
  final IconData? icono;
  final Color? colorFondo;
  final Color? colorTexto;
  final Color? colorBorde;
  final VoidCallback? onPressed;
  final double radioBorde;
  final double paddingHorizontal;
  final double paddingVertical;
  final double? ancho;
  final double? alto;
  final bool estaCargando;
  final bool estaHabilitado;
  final TamanoBotonChiclet tamano;
  final EstiloBotonChiclet estilo;
  final double? elevacion;
  final bool conSombreado;
  final bool conBordes;
  final double grosorSombreado;

  const ChicletButton({
    super.key,
    required this.texto,
    this.icono,
    this.colorFondo,
    this.colorTexto,
    this.colorBorde,
    this.onPressed,
    this.radioBorde = 24,
    this.paddingHorizontal = 16,
    this.paddingVertical = 8, // Reducido de 12 a 8 para mejor proporción
    this.ancho,
    this.alto,
    this.estaCargando = false,
    this.estaHabilitado = true,
    this.tamano = TamanoBotonChiclet.mediano,
    this.estilo = EstiloBotonChiclet.relleno,
    this.elevacion,
    this.conSombreado = true,
    this.conBordes = false,
    this.grosorSombreado = 4.0,
  });

  @override
  State<ChicletButton> createState() => _ChicletButtonState();
}

class _ChicletButtonState extends State<ChicletButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controladorAnimacion;
  late Animation<double> _animacionEscala;

  @override
  void initState() {
    super.initState();
    _controladorAnimacion = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animacionEscala = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controladorAnimacion,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controladorAnimacion.dispose();
    super.dispose();
  }

  void _manejarPresionBoton(TapDownDetails details) {
    if (widget.estaHabilitado && !widget.estaCargando) {
      _controladorAnimacion.forward();
      HapticFeedbackHelper.vibracionSeleccion();
    }
  }

  void _manejarSoltarBoton(TapUpDetails details) {
    if (widget.estaHabilitado && !widget.estaCargando) {
      _controladorAnimacion.reverse();
    }
  }

  void _manejarCancelarPresionBoton() {
    if (widget.estaHabilitado && !widget.estaCargando) {
      _controladorAnimacion.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final estaHabilitado = widget.estaHabilitado && !widget.estaCargando;
    final configuracionTamano = _obtenerConfiguracionTamano();
    final configuracionColor = _obtenerConfiguracionColor(tema, estaHabilitado);

    return AnimatedBuilder(
      animation: _animacionEscala,
      builder: (context, child) {
        return Transform.scale(
          scale: _animacionEscala.value,
          child: Container(
            width: widget.ancho,
            height: widget.alto ?? configuracionTamano.altura,
            decoration: BoxDecoration(
              color: configuracionColor.colorFondo,
              borderRadius: BorderRadius.circular(widget.radioBorde),
              border: widget.estilo == EstiloBotonChiclet.contorno
                  ? Border.all(
                      color:
                          configuracionColor.colorBorde ?? Colors.transparent,
                      width: 2,
                    )
                  : null,
              boxShadow: widget.conSombreado &&
                      widget.estilo != EstiloBotonChiclet.texto
                  ? [
                      BoxShadow(
                        color:
                            _calcularColorSombra(configuracionColor.colorFondo),
                        offset: Offset(0, widget.grosorSombreado),
                        blurRadius: 0,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.radioBorde),
                onTap: estaHabilitado ? widget.onPressed : null,
                onTapDown: _manejarPresionBoton,
                onTapUp: _manejarSoltarBoton,
                onTapCancel: _manejarCancelarPresionBoton,
                child: Container(
                  padding: _obtenerPaddingOptimo(),
                  child: _buildContent(configuracionColor, configuracionTamano),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Método para obtener el padding óptimo según el tamaño
  EdgeInsets _obtenerPaddingOptimo() {
    switch (widget.tamano) {
      case TamanoBotonChiclet.pequeno:
        return EdgeInsets.symmetric(
          horizontal:
              widget.paddingHorizontal * 0.8, // Reducir padding horizontal
          vertical: widget.paddingVertical * 0.6, // Reducir padding vertical
        );
      case TamanoBotonChiclet.mediano:
        return EdgeInsets.symmetric(
          horizontal: widget.paddingHorizontal,
          vertical: widget.paddingVertical,
        );
      case TamanoBotonChiclet.grande:
        return EdgeInsets.symmetric(
          horizontal: widget.paddingHorizontal * 1.2, // Aumentar padding
          vertical: widget.paddingVertical * 1.1,
        );
    }
  }

  Widget _buildContent(
    _ConfiguracionColor configuracionColor,
    _ConfiruacionTamano configuracionTamano,
  ) {
    if (widget.estaCargando) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: configuracionTamano.tamanoIcono,
            height: configuracionTamano.tamanoIcono,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(configuracionColor.colorTexto),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Cargando...',
            style: TextStyle(
              color: configuracionColor.colorTexto,
              fontWeight: FontWeight.bold,
              fontSize: configuracionTamano.tamanoFuente,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icono != null) ...[
          Icon(
            widget.icono,
            color: configuracionColor.colorTexto,
            size: configuracionTamano.tamanoIcono,
          ),
          if (widget.texto.isNotEmpty) const SizedBox(width: 8),
        ],
        if (widget.texto.isNotEmpty)
          Flexible(
            child: Text(
              widget.texto,
              style: TextStyle(
                color: configuracionColor.colorTexto,
                fontWeight: FontWeight.bold,
                fontSize: configuracionTamano.tamanoFuente,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
      ],
    );
  }

  _ConfiruacionTamano _obtenerConfiguracionTamano() {
    switch (widget.tamano) {
      case TamanoBotonChiclet.pequeno:
        return _ConfiruacionTamano(
          altura: 40, // Aumentado de 36 a 40 para mejor legibilidad
          tamanoFuente: 14,
          tamanoIcono: 16,
          elevacion: 2,
        );
      case TamanoBotonChiclet.mediano:
        return _ConfiruacionTamano(
          altura: 48,
          tamanoFuente: 16,
          tamanoIcono: 20,
          elevacion: 4,
        );
      case TamanoBotonChiclet.grande:
        return _ConfiruacionTamano(
          altura: 56,
          tamanoFuente: 18,
          tamanoIcono: 24,
          elevacion: 6,
        );
    }
  }

  _ConfiguracionColor _obtenerConfiguracionColor(
    ThemeData tema,
    bool estaHabilitado,
  ) {
    Color colorFondo;
    Color colorTexto;
    Color? colorBorde;

    if (!estaHabilitado) {
      colorFondo = tema.disabledColor.withOpacity(0.3);
      colorTexto = tema.disabledColor;
      colorBorde = tema.disabledColor;
    } else {
      switch (widget.estilo) {
        case EstiloBotonChiclet.relleno:
          colorFondo = widget.colorFondo ?? AppColors.primary;
          colorTexto = widget.colorTexto ?? Colors.white;
          break;
        case EstiloBotonChiclet.contorno:
          colorFondo = Colors.white;
          colorTexto =
              widget.colorTexto ?? widget.colorFondo ?? AppColors.primary;
          colorBorde =
              widget.colorBorde ?? widget.colorFondo ?? AppColors.primary;
          break;
        case EstiloBotonChiclet.texto:
          colorFondo = Colors.transparent;
          colorTexto =
              widget.colorTexto ?? widget.colorFondo ?? AppColors.primary;
          break;
      }
    }

    return _ConfiguracionColor(
      colorFondo: colorFondo,
      colorTexto: colorTexto,
      colorBorde: colorBorde,
    );
  }

  // Método para calcular el color del sombreado estilo Duolingo
  Color _calcularColorSombra(Color colorBase) {
    // Si es blanco, usamos un gris claro
    if (colorBase == Colors.white) {
      return Colors.grey.shade300;
    }

    // Para otros colores, oscurecemos un 20-30%
    final hsl = HSLColor.fromColor(colorBase);
    return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
  }
}

// Enums para configuración del botón
enum TamanoBotonChiclet {
  pequeno,
  mediano,
  grande,
}

enum EstiloBotonChiclet {
  relleno,
  contorno,
  texto,
}

class _ConfiruacionTamano {
  final double altura;
  final double tamanoFuente;
  final double tamanoIcono;
  final double elevacion;

  _ConfiruacionTamano({
    required this.altura,
    required this.tamanoFuente,
    required this.tamanoIcono,
    required this.elevacion,
  });
}

class _ConfiguracionColor {
  final Color colorFondo;
  final Color colorTexto;
  final Color? colorBorde;

  _ConfiguracionColor({
    required this.colorFondo,
    required this.colorTexto,
    this.colorBorde,
  });
}
