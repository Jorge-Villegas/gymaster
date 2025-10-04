import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:gymaster/shared/widgets/menu_lateral.dart';
import 'package:gymaster/core/theme/app_colors.dart';

class PaginaConMenuLateral extends StatefulWidget {
  const PaginaConMenuLateral({
    super.key,
    required this.contenidoPrincipal,
    this.mostrarBotonMenu = true,
    this.selectedIndex = 0,
    this.onMenuSelected,
  });

  final Widget contenidoPrincipal;
  final bool mostrarBotonMenu;
  final int selectedIndex;
  final Function(int index)? onMenuSelected;

  @override
  State<PaginaConMenuLateral> createState() => _PaginaConMenuLateralState();

  /// Método estático para alternar el menú desde cualquier lugar
  static void alternarMenuDesdeContext(BuildContext context) {
    final state = context.findAncestorStateOfType<_PaginaConMenuLateralState>();
    state?._alternarMenu();
  }
}

class _PaginaConMenuLateralState extends State<PaginaConMenuLateral>
    with TickerProviderStateMixin {
  late AnimationController? _controladorAnimacion;
  late Animation<double> _animacionMenuLateral;

  bool _menuEstaAbierto = false;

  @override
  void initState() {
    super.initState();

    _controladorAnimacion = AnimationController(
      duration: const Duration(milliseconds: 300),
      upperBound: 1,
      vsync: this,
    );

    _animacionMenuLateral = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controladorAnimacion!,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controladorAnimacion?.dispose();
    super.dispose();
  }

  void _alternarMenu() {
    setState(() {
      _menuEstaAbierto = !_menuEstaAbierto;
    });

    if (_menuEstaAbierto) {
      _controladorAnimacion?.forward();
      // Cambiar el color de la barra de estado cuando el menú está abierto
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    } else {
      _controladorAnimacion?.reverse();
      // Restaurar el color de la barra de estado
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
  }

  void _cerrarMenu() {
    if (_menuEstaAbierto) {
      setState(() {
        _menuEstaAbierto = false;
      });
      _controladorAnimacion?.reverse();
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul oscuro que ocupa toda la pantalla cuando el menú está abierto
          AnimatedBuilder(
            animation: _animacionMenuLateral,
            builder: (context, child) {
              return Container(
                color: AppColors.fondoTerciarioOscuro.withValues(
                  alpha: (_animacionMenuLateral.value > 0.01) ? 1.0 : 0.0,
                ),
              );
            },
          ),

          // Menú lateral con animación de desvanecimiento
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _animacionMenuLateral,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(((1 - _animacionMenuLateral.value) * -30) *
                        math.pi /
                        180)
                    ..translate((1 - _animacionMenuLateral.value) * -300),
                  child: child,
                );
              },
              child: FadeTransition(
                opacity: _animacionMenuLateral,
                child: MenuLateral(
                  onMenuSelected: (index) {
                    widget.onMenuSelected?.call(index);
                    _cerrarMenu(); // Cerrar menú después de seleccionar
                  },
                  selectedIndex: widget.selectedIndex,
                ),
              ),
            ),
          ),

          // Contenido principal con animaciones de escala y traslación
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _animacionMenuLateral,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 - (_animacionMenuLateral.value * 0.08),
                  child: Transform.translate(
                    offset: Offset(_animacionMenuLateral.value * 260, 0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            (_animacionMenuLateral.value * 15) * math.pi / 180),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          _animacionMenuLateral.value * 20,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: widget.contenidoPrincipal,
            ),
          ),

          // Botón del menú ahora se integra en las cabeceras individuales

          // Área invisible para cerrar el menú tocando el contenido principal
          if (_menuEstaAbierto)
            AnimatedBuilder(
              animation: _animacionMenuLateral,
              builder: (context, child) {
                return Positioned(
                  left: 288, // Comenzar después del ancho del menú
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _cerrarMenu,
                    child: Container(
                      color: Colors.transparent, // Completamente transparente
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
