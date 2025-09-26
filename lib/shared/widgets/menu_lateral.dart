import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_cubit.dart';
import 'package:gymaster/features/setting/presentation/cubit/setting_state.dart';
import 'package:gymaster/shared/models/elemento_menu_modelo.dart';
import 'package:gymaster/shared/widgets/seccion_botones_menu.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'dart:math' as math;
import 'package:gymaster/core/theme/app_colors.dart';

class MenuLateral extends StatefulWidget {
  const MenuLateral({
    super.key,
    this.onMenuSelected,
    this.selectedIndex = 0,
  });

  final Function(int index)? onMenuSelected;
  final int selectedIndex;

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  // Elementos del menú organizados por secciones - estilo flutter-samples
  final List<ElementoMenuModelo> _elementosNavegacion = [
    ElementoMenuModelo(
      id: 'rutinas',
      titulo: 'Mis Rutinas',
      icono: IconsaxPlusLinear.weight,
      ruta: '/main',
      indiceNavegacion: 0,
    ),
    ElementoMenuModelo(
      id: 'ejercicios',
      titulo: 'Catálogo de Ejercicios',
      icono: IconsaxPlusLinear.activity,
      ruta: '/main',
      indiceNavegacion: 2,
    ),
    ElementoMenuModelo(
      id: 'favoritos',
      titulo: 'Favoritos',
      icono: IconsaxPlusLinear.heart,
      ruta: '/main',
      indiceNavegacion: 1, // Página de favoritos
    ),
    ElementoMenuModelo(
      id: 'configuracion',
      titulo: 'Configuración',
      icono: IconsaxPlusLinear.setting_2,
      ruta: '/main',
      indiceNavegacion: 4,
    ),
  ];

  final List<ElementoMenuModelo> _elementosSeguimiento = [
    ElementoMenuModelo(
      id: 'historial',
      titulo: 'Historial',
      icono: IconsaxPlusLinear.chart,
      ruta: '/main',
      indiceNavegacion: 3,
    ),
    ElementoMenuModelo(
      id: 'notificaciones',
      titulo: 'Notificaciones',
      icono: IconsaxPlusLinear.notification,
      ruta: '/main',
      indiceNavegacion: 4, // Temporalmente configuración
    ),
  ];

  String _menuSeleccionado = 'Mis Rutinas';

  void _alPresionarMenu(ElementoMenuModelo menu) {
    // Actualizar el estado visual
    setState(() {
      _menuSeleccionado = menu.titulo;
    });

    // Debug: Mostrar mensaje para confirmar que el tap funciona
    print('Menu seleccionado: ${menu.titulo}');

    // Navegar a la página correspondiente usando el índice
    if (menu.indiceNavegacion != null && widget.onMenuSelected != null) {
      widget.onMenuSelected!(menu.indiceNavegacion!);

      // Mostrar feedback visual de navegación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ Navegando a ${menu.titulo}'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } else {
      // Mostrar feedback para elementos sin navegación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${menu.titulo} - Próximamente'),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
        ),
      );
    }

    // Ejecutar acción personalizada si existe
    if (menu.accion != null) {
      menu.accion!();
    }
  }

  void _alternarTemaOscuro(bool valor) {
    context.read<SettingCubit>().toggleDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final mediaPadding = MediaQuery.of(context).padding;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        bool esTemaOscuro = false;

        if (state is SettingLoaded) {
          esTemaOscuro = state.isDarkMode;
        }

        return Container(
          width: 288, // Ancho exacto como flutter-samples
          height: double.infinity,
          padding: EdgeInsets.only(
            top: mediaPadding.top,
            bottom: math.max(0, mediaPadding.bottom - 60),
          ),
          decoration: const BoxDecoration(
            // Fondo azul oscuro que ocupa toda la altura sin bordes redondeados
            color: AppColors.menuDarkBlue,
            // Sin borderRadius para que ocupe toda la pantalla de arriba a abajo
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección del perfil de usuario
              _construirSeccionPerfil(tema),

              const SizedBox(height: 16),

              // Contenido scrolleable del menú
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Sección BROWSE - como flutter-samples
                      SeccionBotonesMenu(
                        titulo: "BROWSE",
                        menuSeleccionado: _menuSeleccionado,
                        elementosMenu: _elementosNavegacion,
                        alPresionarMenu: _alPresionarMenu,
                      ),

                      // Sección HISTORY - como flutter-samples
                      SeccionBotonesMenu(
                        titulo: "HISTORY",
                        menuSeleccionado: _menuSeleccionado,
                        elementosMenu: _elementosSeguimiento,
                        alPresionarMenu: _alPresionarMenu,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Control de tema oscuro
              _construirControlTema(tema, esTemaOscuro),
            ],
          ),
        );
      },
    );
  }

  Widget _construirSeccionPerfil(ThemeData tema) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            foregroundColor: Colors.white,
            child: const Icon(
              IconsaxPlusLinear.user,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Usuario GyMaster",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: "Inter",
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Entrenador Personal",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 15,
                  fontFamily: "Inter",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _construirControlTema(ThemeData tema, bool esTemaOscuro) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: Opacity(
              opacity: 0.6,
              child: Icon(
                esTemaOscuro ? IconsaxPlusLinear.moon : IconsaxPlusLinear.sun_1,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Tema Oscuro",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CupertinoSwitch(
            value: esTemaOscuro,
            onChanged: _alternarTemaOscuro,
          ),
        ],
      ),
    );
  }
}
