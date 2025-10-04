import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/estadisticas/presentation/cubits/estadisticas_cubit.dart';
import 'package:gymaster/features/estadisticas/presentation/pages/estadisticas_page.dart';
import 'package:gymaster/features/record/presentation/pages/historial_ejercicios_page.dart';
import 'package:gymaster/init_dependencies.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

/// Página contenedora con tabs para Historial y Estadísticas.
class HistorialConEstadisticasPage extends StatefulWidget {
  final int initialTabIndex;

  const HistorialConEstadisticasPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<HistorialConEstadisticasPage> createState() =>
      _HistorialConEstadisticasPageState();
}

class _HistorialConEstadisticasPageState
    extends State<HistorialConEstadisticasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipal,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.fondoSecundario,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.borde.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primario,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.primario,
                unselectedLabelColor: AppColors.textoSecundario,
                labelStyle: TextStyle(
                  fontSize: TipografiaGyMaster.tamanoMd,
                  fontWeight: TipografiaGyMaster.pesoSemiBold,
                  color: AppColors.textoPrincipal,
                  height: 1.4,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: TipografiaGyMaster.tamanoMd,
                  fontWeight: TipografiaGyMaster.pesoRegular,
                  color: AppColors.textoTerciario,
                  height: 1.3,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(IconsaxPlusLinear.document_text, size: 22),
                    text: 'Historial',
                  ),
                  Tab(
                    icon: Icon(IconsaxPlusLinear.chart_2, size: 22),
                    text: 'Estadísticas',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  HistorialEjerciciosPage(),
                  BlocProvider(
                    create: (context) => serviceLocator<EstadisticasCubit>(),
                    child: const EstadisticasPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
