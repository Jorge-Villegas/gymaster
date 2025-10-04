import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/app_colors.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/features/estadisticas/domain/entities/periodo_tiempo.dart';

/// Widget selector de periodo de tiempo con chips interactivos.
///
/// Muestra los diferentes periodos disponibles (Hoy, Semana, Mes, Año, Todo)
/// siguiendo el sistema de diseño de GyMaster.
class SelectorPeriodoWidget extends StatelessWidget {
  final PeriodoTiempo periodoSeleccionado;
  final Function(PeriodoTiempo) onPeriodoSeleccionado;

  const SelectorPeriodoWidget({
    super.key,
    required this.periodoSeleccionado,
    required this.onPeriodoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    final periodos = [
      PeriodoTiempo.hoy,
      PeriodoTiempo.semanaActual,
      PeriodoTiempo.mesActual,
      PeriodoTiempo.anoActual,
      PeriodoTiempo.todoElTiempo,
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: Espaciado.rellenoHorizontalMd,
        itemCount: periodos.length,
        separatorBuilder: (_, __) => SizedBox(width: Espaciado.xs),
        itemBuilder: (context, index) {
          final periodo = periodos[index];
          final estaSeleccionado = periodo == periodoSeleccionado;

          return _ChipPeriodo(
            label: periodo.etiqueta,
            estaSeleccionado: estaSeleccionado,
            onTap: () => onPeriodoSeleccionado(periodo),
          );
        },
      ),
    );
  }
}

class _ChipPeriodo extends StatelessWidget {
  final String label;
  final bool estaSeleccionado;
  final VoidCallback onTap;

  const _ChipPeriodo({
    required this.label,
    required this.estaSeleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: estaSeleccionado
              ? AppColors.primario
              : AppColors.fondoSecundarioClaro,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: estaSeleccionado
                ? AppColors.primario
                : AppColors.borde.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: TipografiaGyMaster.tamanoSm,
            fontWeight: estaSeleccionado
                ? TipografiaGyMaster.pesoSemiBold
                : TipografiaGyMaster.pesoRegular,
            color: estaSeleccionado
                ? Colors.white
                : AppColors.textoPrincipalOscuro,
          ),
        ),
      ),
    );
  }
}
