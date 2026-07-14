import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/features/exercise/presentation/pages/exercise_catalog_page.dart';
import 'package:gymaster/features/home/presentation/pages/home_page.dart';
import 'package:gymaster/features/record/presentation/pages/historial_con_estadisticas_page.dart';
import 'package:gymaster/features/routine/presentation/pages/lista_rutina_page.dart';
import 'package:gymaster/features/setting/presentation/pages/setting_page.dart';
import 'package:gymaster/shared/widgets/gym/gym.dart';

/// Shell de navegación principal: bottom nav estilo Duolingo con 5 secciones.
/// Reemplaza a la antigua `BottomNavigationBarExampleApp` (barra de ejemplo).
class BottomNavigationBarExampleApp extends StatefulWidget {
  final int initialIndex;

  const BottomNavigationBarExampleApp({super.key, this.initialIndex = 0});

  @override
  State<BottomNavigationBarExampleApp> createState() =>
      _BottomNavigationBarExampleAppState();
}

class _BottomNavigationBarExampleAppState
    extends State<BottomNavigationBarExampleApp> {
  late int _selectedIndex = widget.initialIndex;

  static const _items = [
    GymNavItem(IconsaxPlusLinear.home_2, 'Inicio'),
    GymNavItem(IconsaxPlusLinear.weight, 'Rutinas'),
    GymNavItem(IconsaxPlusLinear.grid_2, 'Ejercicios'),
    GymNavItem(IconsaxPlusLinear.chart_2, 'Progreso'),
    GymNavItem(IconsaxPlusLinear.profile, 'Perfil'),
  ];

  void _goTo(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onEntrenar: () => _goTo(1)),
      const ListaRutinasPage(),
      const ExerciseCatalogPage(),
      const HistorialConEstadisticasPage(),
      const SettingPage(),
    ];

    return Scaffold(
      backgroundColor: context.gym.bg,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: GymBottomNav(
        index: _selectedIndex,
        onChanged: _goTo,
        items: _items,
      ),
    );
  }
}
