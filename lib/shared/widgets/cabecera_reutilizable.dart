import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';

/// Widget reutilizable para crear cabeceras consistentes en toda la aplicación
///
/// Implementa diseño emocional y patrones de usabilidad:
/// - Botón de navegación izquierdo personalizable
/// - Área central para título y subtítulo
/// - Área de acciones derechas flexible
/// - Animaciones suaves de entrada
/// - Estilos consistentes con la paleta de colores
class CabeceraReutilizable extends StatelessWidget {
  /// Título principal de la cabecera
  final String titulo;

  /// Subtítulo opcional (descripción, saludo, etc.)
  final String? subtitulo;

  /// Configuración del botón izquierdo de navegación
  final ConfiguracionBotonIzquierdo? botonIzquierdo;

  /// Lista de botones/acciones para el lado derecho
  final List<Widget>? accionesDerecha;

  /// Color de fondo del contenedor principal
  final Color? colorFondo;

  /// Padding personalizado (usa valores estándar si no se especifica)
  final EdgeInsets? relleno;

  /// Duración de la animación de entrada
  final Duration duracionAnimacion;

  /// Si debe mostrar animación de entrada o no
  final bool conAnimacion;

  const CabeceraReutilizable({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.botonIzquierdo,
    this.accionesDerecha,
    this.colorFondo,
    this.relleno,
    this.duracionAnimacion = const Duration(milliseconds: 800),
    this.conAnimacion = true,
  });

  @override
  Widget build(BuildContext context) {
    final contenido = Container(
      padding: relleno ?? Espaciado.rellenoMd,
      decoration: colorFondo != null ? BoxDecoration(color: colorFondo) : null,
      child: Row(
        children: [
          // Botón izquierdo de navegación
          if (botonIzquierdo != null) ...[
            _construirBotonIzquierdo(context),
            Espaciado.separacionHorizontalSm,
          ],

          // Área central con título y subtítulo
          Expanded(
            child: _construirAreaCentral(),
          ),

          // Acciones del lado derecho
          if (accionesDerecha != null && accionesDerecha!.isNotEmpty) ...[
            Espaciado.separacionHorizontalSm,
            ...accionesDerecha!.map((accion) => Padding(
                  padding: const EdgeInsets.only(left: Espaciado.sm),
                  child: accion,
                )),
          ],
        ],
      ),
    );

    // Aplicar animación si está habilitada
    if (conAnimacion) {
      return FadeInDown(
        duration: duracionAnimacion,
        child: contenido,
      );
    }

    return contenido;
  }

  /// Construye el botón izquierdo basado en la configuración
  Widget _construirBotonIzquierdo(BuildContext context) {
    final config = botonIzquierdo!;

    return Container(
      decoration: BoxDecoration(
        color: config.colorFondo ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: config.conSombra
            ? [
                BoxShadow(
                  color: (config.colorSombra ?? AppColors.primary)
                      .withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: IconButton(
        onPressed: () => _manejarAccionBotonIzquierdo(context, config),
        icon: Icon(
          config.icono,
          color: config.colorIcono ?? AppColors.primario,
          size: config.tamanoIcono,
        ),
        padding: EdgeInsets.all(config.relleno),
        tooltip: config.tooltip,
      ),
    );
  }

  /// Construye el área central con título y subtítulo
  Widget _construirAreaCentral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontWeight: TipografiaGyMaster.pesoSemiBold,
            fontSize: TipografiaGyMaster.tamanoXl,
            color: AppColors.impulsoEntrenamiento,
            height: 1.1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitulo != null) ...[
          const SizedBox(height: Espaciado.xxs),
          Text(
            subtitulo!,
            style: TextStyle(
              fontWeight: TipografiaGyMaster.pesoLigero,
              fontSize: TipografiaGyMaster.tamanoSm,
              letterSpacing: 0.4,
              height: 1.3,
              color: AppColors.primarioCalido,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// Maneja las acciones del botón izquierdo basado en el tipo
  void _manejarAccionBotonIzquierdo(
      BuildContext context, ConfiguracionBotonIzquierdo config) {
    switch (config.tipo) {
      case TipoBotonIzquierdo.volver:
        if (config.accionPersonalizada != null) {
          config.accionPersonalizada!();
        } else {
          // Priorizar GoRouter si está disponible, sino usar Navigator
          if (GoRouter.maybeOf(context) != null && context.canPop()) {
            context.pop();
          } else {
            Navigator.of(context).maybePop();
          }
        }
        break;
      case TipoBotonIzquierdo.menu:
        if (config.accionPersonalizada != null) {
          config.accionPersonalizada!();
        } else {
          Scaffold.of(context).openDrawer();
        }
        break;
      case TipoBotonIzquierdo.personalizado:
        config.accionPersonalizada?.call();
        break;
    }
  }
}

/// Configuración para el botón izquierdo de la cabecera
class ConfiguracionBotonIzquierdo {
  /// Tipo de botón que determina el comportamiento por defecto
  final TipoBotonIzquierdo tipo;

  /// Icono a mostrar
  final IconData icono;

  /// Color del fondo del botón
  final Color? colorFondo;

  /// Color del icono
  final Color? colorIcono;

  /// Color de la sombra
  final Color? colorSombra;

  /// Tamaño del icono
  final double tamanoIcono;

  /// Padding interno del botón
  final double relleno;

  /// Si debe mostrar sombra
  final bool conSombra;

  /// Tooltip descriptivo
  final String? tooltip;

  /// Acción personalizada (anula el comportamiento por defecto)
  final VoidCallback? accionPersonalizada;

  const ConfiguracionBotonIzquierdo({
    required this.tipo,
    required this.icono,
    this.colorFondo,
    this.colorIcono,
    this.colorSombra,
    this.tamanoIcono = 20,
    this.relleno = 12,
    this.conSombra = true,
    this.tooltip,
    this.accionPersonalizada,
  });

  /// Factory para crear un botón de volver estándar
  factory ConfiguracionBotonIzquierdo.volver({
    VoidCallback? accionPersonalizada,
    Color? colorIcono,
    String? tooltip,
  }) {
    return ConfiguracionBotonIzquierdo(
      tipo: TipoBotonIzquierdo.volver,
      icono: Icons.arrow_back_ios_rounded,
      colorIcono: colorIcono,
      tooltip: tooltip ?? 'Volver',
      accionPersonalizada: accionPersonalizada,
    );
  }

  /// Factory para crear un botón de menú estándar
  factory ConfiguracionBotonIzquierdo.menu({
    VoidCallback? accionPersonalizada,
    Color? colorIcono,
    String? tooltip,
  }) {
    return ConfiguracionBotonIzquierdo(
      tipo: TipoBotonIzquierdo.menu,
      icono: Icons.menu_rounded,
      colorIcono: colorIcono,
      tooltip: tooltip ?? 'Menú',
      accionPersonalizada: accionPersonalizada,
    );
  }

  /// Factory para crear un botón personalizado
  factory ConfiguracionBotonIzquierdo.personalizado({
    required IconData icono,
    required VoidCallback accion,
    Color? colorFondo,
    Color? colorIcono,
    Color? colorSombra,
    double? tamanoIcono,
    double? relleno,
    bool? conSombra,
    String? tooltip,
  }) {
    return ConfiguracionBotonIzquierdo(
      tipo: TipoBotonIzquierdo.personalizado,
      icono: icono,
      colorFondo: colorFondo,
      colorIcono: colorIcono,
      colorSombra: colorSombra,
      tamanoIcono: tamanoIcono ?? 20,
      relleno: relleno ?? 12,
      conSombra: conSombra ?? true,
      tooltip: tooltip,
      accionPersonalizada: accion,
    );
  }
}

/// Tipos de botones izquierdos soportados
enum TipoBotonIzquierdo {
  /// Botón para volver a la pantalla anterior
  volver,

  /// Botón para abrir el menú lateral/drawer
  menu,

  /// Botón con comportamiento personalizado
  personalizado,
}

/// Widget para crear botones de acción estándar en el lado derecho
class BotonAccionDerecha extends StatelessWidget {
  /// Icono del botón
  final IconData icono;

  /// Acción a ejecutar al presionar
  final VoidCallback onPressed;

  /// Color de fondo del botón
  final Color? colorFondo;

  /// Color del icono
  final Color? colorIcono;

  /// Tamaño del icono
  final double? tamanoIcono;

  /// Si debe mostrar sombra
  final bool conSombra;

  /// Tooltip descriptivo
  final String? tooltip;

  const BotonAccionDerecha({
    super.key,
    required this.icono,
    required this.onPressed,
    this.colorFondo,
    this.colorIcono,
    this.tamanoIcono,
    this.conSombra = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorFondo ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: conSombra
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icono,
          color: colorIcono ?? AppColors.primario,
          size: tamanoIcono ?? 20,
        ),
        padding: const EdgeInsets.all(12),
        tooltip: tooltip,
      ),
    );
  }

  /// Factory para crear un botón de búsqueda estándar
  factory BotonAccionDerecha.buscar({
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return BotonAccionDerecha(
      icono: Icons.search_rounded,
      onPressed: onPressed,
      tooltip: tooltip ?? 'Buscar',
    );
  }

  /// Factory para crear un botón de agregar estándar
  factory BotonAccionDerecha.agregar({
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return BotonAccionDerecha(
      icono: Icons.add_rounded,
      onPressed: onPressed,
      tooltip: tooltip ?? 'Agregar',
    );
  }

  /// Factory para crear un botón de actualizar estándar
  factory BotonAccionDerecha.actualizar({
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return BotonAccionDerecha(
      icono: Icons.refresh_rounded,
      onPressed: onPressed,
      tooltip: tooltip ?? 'Actualizar',
    );
  }

  /// Factory para crear un botón de favoritos estándar
  factory BotonAccionDerecha.favoritos({
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return BotonAccionDerecha(
      icono: Icons.favorite_rounded,
      onPressed: onPressed,
      colorIcono: Colors.red.shade600,
      tooltip: tooltip ?? 'Favoritos',
    );
  }
}
