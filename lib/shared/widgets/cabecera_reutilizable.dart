import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/shared/widgets/pagina_con_menu_lateral.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Widget reutilizable para crear cabeceras consistentes en toda la aplicación
///
/// Implementa diseño emocional y patrones de usabilidad:
/// - Botón de navegación izquierdo personalizable
/// - Área central para título y subtítulo
/// - Área de acciones derechas flexible
/// - Búsqueda expandible con animaciones suaves
/// - Animaciones suaves de entrada
/// - Estilos consistentes con la paleta de colores
class CabeceraReutilizable extends StatefulWidget {
  /// Título principal de la cabecera
  final String titulo;

  /// Subtítulo opcional (descripción, saludo, etc.)
  final String? subtitulo;

  /// Configuración del botón izquierdo de navegación
  final ConfiguracionBotonIzquierdo? botonIzquierdo;

  /// Lista de botones/acciones para el lado derecho
  final List<Widget>? accionesDerecha;

  /// Configuración de búsqueda expandible (opcional)
  final ConfiguracionBusqueda? busqueda;

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
    this.busqueda,
    this.colorFondo,
    this.relleno,
    this.duracionAnimacion = const Duration(milliseconds: 800),
    this.conAnimacion = true,
  });

  @override
  State<CabeceraReutilizable> createState() => _CabeceraReutilizableState();
}

class _CabeceraReutilizableState extends State<CabeceraReutilizable>
    with TickerProviderStateMixin {
  AnimationController? _searchAnimationController;
  TextEditingController? _searchController;
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();

    // Solo inicializar controladores si hay configuración de búsqueda
    if (widget.busqueda != null) {
      _searchAnimationController = AnimationController(
        duration: widget.busqueda!.duracionAnimacion,
        vsync: this,
      );
      _searchController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _searchAnimationController?.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contenido = Container(
      padding: widget.relleno ?? Espaciado.rellenoMd,
      decoration: widget.colorFondo != null
          ? BoxDecoration(color: widget.colorFondo)
          : null,
      child: _construirContenidoPrincipal(),
    );

    // Aplicar animación si está habilitada
    if (widget.conAnimacion) {
      return FadeInDown(
        duration: widget.duracionAnimacion,
        child: contenido,
      );
    }

    return contenido;
  }

  /// Construye el contenido principal con o sin animaciones
  Widget _construirContenidoPrincipal() {
    final filaContenido = Row(
      children: [
        // Botón izquierdo de navegación
        if (widget.botonIzquierdo != null) ...[
          _construirBotonIzquierdo(context),
          Espaciado.separacionHorizontalSm,
        ],

        // Área central con título/subtítulo o campo de búsqueda
        Expanded(
          child: _isSearchExpanded && widget.busqueda != null
              ? _construirCampoBusquedaExpandido()
              : _construirAreaCentral(),
        ),

        // Acciones del lado derecho y botón de búsqueda
        if (widget.accionesDerecha != null &&
            widget.accionesDerecha!.isNotEmpty) ...[
          Espaciado.separacionHorizontalSm,
          ...widget.accionesDerecha!.map((accion) => Padding(
                padding: const EdgeInsets.only(left: Espaciado.sm),
                child: accion,
              )),
        ],

        // Botón de búsqueda (si está configurado)
        if (widget.busqueda != null) ...[
          Espaciado.separacionHorizontalSm,
          _construirBotonBusqueda(),
        ],
      ],
    );

    // Solo usar AnimatedBuilder si hay configuración de búsqueda
    if (widget.busqueda != null) {
      return AnimatedBuilder(
        animation: _searchAnimationController!,
        builder: (context, child) => filaContenido,
      );
    }

    // Sin animaciones si no hay búsqueda
    return filaContenido;
  }

  /// Construye el botón izquierdo basado en la configuración
  Widget _construirBotonIzquierdo(BuildContext context) {
    final config = widget.botonIzquierdo!;

    return Container(
      decoration: BoxDecoration(
        color: config.colorFondo ?? context.gym.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: config.conSombra
            ? [
                BoxShadow(
                  color: (config.colorSombra ?? context.gym.brand)
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
          color: config.colorIcono ?? context.gym.brand,
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
          widget.titulo,
          style: GymType.title.copyWith(
            color: context.gym.ink,
            height: 1.1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.subtitulo != null) ...[
          const SizedBox(height: Espaciado.xxs),
          Text(
            widget.subtitulo!,
            style: GymType.body.copyWith(
              letterSpacing: 0.4,
              height: 1.3,
              color: context.gym.muted,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// Construye el campo de búsqueda expandido con animación
  Widget _construirCampoBusquedaExpandido() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _searchAnimationController!,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        decoration: BoxDecoration(
          color: context.gym.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.gym.brand.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
          border: Border.all(
            color: context.gym.brand.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: GymType.body.copyWith(
            color: context.gym.ink,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: widget.busqueda!.placeholderText,
            hintStyle: GymType.body.copyWith(
              color: context.gym.faint,
              fontSize: 16,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.gym.brand.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                IconsaxPlusLinear.search_normal,
                color: context.gym.brand,
                size: 20,
              ),
            ),
            suffixIcon: _searchController!.text.isNotEmpty
                ? IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: context.gym.faint.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: context.gym.faint,
                        size: 16,
                      ),
                    ),
                    onPressed: _limpiarBusqueda,
                  )
                : null,
          ),
          onChanged: widget.busqueda!.onBusqueda,
          onSubmitted: widget.busqueda!.onBusqueda,
        ),
      ),
    );
  }

  /// Construye el botón de búsqueda con animación
  Widget _construirBotonBusqueda() {
    return GestureDetector(
      onTap: _alternarBusqueda,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              _isSearchExpanded ? context.gym.brand : context.gym.surface2,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: context.gym.brand.withValues(alpha: 0.2),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _isSearchExpanded
                ? Icons.close_rounded
                : IconsaxPlusLinear.search_normal,
            key: ValueKey(_isSearchExpanded),
            color: _isSearchExpanded ? Colors.white : context.gym.brand,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Alternar el estado de búsqueda con animación
  void _alternarBusqueda() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
    });

    if (_isSearchExpanded) {
      _searchAnimationController!.forward();
    } else {
      _searchAnimationController!.reverse();
      if (_searchController!.text.isNotEmpty) {
        _limpiarBusqueda();
      }
    }
  }

  /// Limpiar el campo de búsqueda
  void _limpiarBusqueda() {
    setState(() {
      _searchController!.clear();
    });
    widget.busqueda!.onLimpiar?.call();
    FocusScope.of(context).unfocus();
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
          PaginaConMenuLateral.alternarMenuDesdeContext(context);
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
        color: colorFondo ?? context.gym.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: conSombra
            ? [
                BoxShadow(
                  color: context.gym.brand.withValues(alpha: 0.1),
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
          color: colorIcono ?? context.gym.brand,
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

/// Configuración para la funcionalidad de búsqueda expandible
class ConfiguracionBusqueda {
  /// Texto del placeholder del campo de búsqueda
  final String placeholderText;

  /// Callback cuando se realiza una búsqueda
  final ValueChanged<String> onBusqueda;

  /// Callback cuando se limpia la búsqueda (opcional)
  final VoidCallback? onLimpiar;

  /// Duración de la animación de expansión
  final Duration duracionAnimacion;

  /// Tooltip del botón de búsqueda
  final String? tooltip;

  const ConfiguracionBusqueda({
    required this.placeholderText,
    required this.onBusqueda,
    this.onLimpiar,
    this.duracionAnimacion = const Duration(milliseconds: 400),
    this.tooltip,
  });

  /// Factory para crear configuración de búsqueda de ejercicios
  factory ConfiguracionBusqueda.ejercicios({
    required ValueChanged<String> onBusqueda,
    VoidCallback? onLimpiar,
  }) {
    return ConfiguracionBusqueda(
      placeholderText: 'Buscar ejercicios...',
      onBusqueda: onBusqueda,
      onLimpiar: onLimpiar,
      tooltip: 'Buscar ejercicios',
    );
  }

  /// Factory para crear configuración de búsqueda de músculos
  factory ConfiguracionBusqueda.musculos({
    required ValueChanged<String> onBusqueda,
    VoidCallback? onLimpiar,
  }) {
    return ConfiguracionBusqueda(
      placeholderText: 'Buscar músculos...',
      onBusqueda: onBusqueda,
      onLimpiar: onLimpiar,
      tooltip: 'Buscar músculos',
    );
  }

  /// Factory para crear configuración de búsqueda de rutinas
  factory ConfiguracionBusqueda.rutinas({
    required ValueChanged<String> onBusqueda,
    VoidCallback? onLimpiar,
  }) {
    return ConfiguracionBusqueda(
      placeholderText: 'Buscar rutinas...',
      onBusqueda: onBusqueda,
      onLimpiar: onLimpiar,
      tooltip: 'Buscar rutinas',
    );
  }

  /// Factory para configuración personalizada
  factory ConfiguracionBusqueda.personalizada({
    required String placeholder,
    required ValueChanged<String> onBusqueda,
    VoidCallback? onLimpiar,
    Duration? duracionAnimacion,
    String? tooltip,
  }) {
    return ConfiguracionBusqueda(
      placeholderText: placeholder,
      onBusqueda: onBusqueda,
      onLimpiar: onLimpiar,
      duracionAnimacion: duracionAnimacion ?? const Duration(milliseconds: 400),
      tooltip: tooltip,
    );
  }
}
