import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/gym_tokens.dart';
import 'package:gymaster/core/theme/gym_typography.dart';
import 'package:gymaster/core/theme/espaciado.dart';
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
    final c = context.gym;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: estaSeleccionado ? c.brand : c.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: estaSeleccionado ? c.brand : c.line,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GymType.label.copyWith(
            fontWeight:
                estaSeleccionado ? FontWeight.w600 : FontWeight.w400,
            color: estaSeleccionado ? Colors.white : c.ink,
          ),
        ),
      ),
    );
  }
}
