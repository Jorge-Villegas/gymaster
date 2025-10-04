import 'package:flutter/material.dart';
import 'package:gymaster/core/theme/tipografia_gymaster.dart';
import 'package:gymaster/core/theme/espaciado.dart';
import 'package:gymaster/core/theme/app_colors.dart';

/// Widget reutilizable para mostrar tarjetas de rutina
/// Implementa reglas de espaciado de 8 puntos y tipografía limitada
class TarjetaRutina extends StatelessWidget {
  final String nombreRutina;
  final String descripcionSeries;
  final String? grupoMuscular;
  final String? estadoRutina;
  final VoidCallback? alTocar;
  final Color? colorPersonalizado;

  const TarjetaRutina({
    super.key,
    required this.nombreRutina,
    required this.descripcionSeries,
    this.grupoMuscular,
    this.estadoRutina,
    this.alTocar,
    this.colorPersonalizado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Espaciado.rellenoVerticalXs,
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: Espaciado.rellenoMd,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: colorPersonalizado?.withValues(alpha: 0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la rutina - Tipografía específica
              Text(
                nombreRutina,
                style: TipografiaGyMaster.nombreRutina,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Separación usando espaciado de 8 puntos
              Espaciado.separacionVerticalXs,

              // Información de series y repeticiones
              Text(
                descripcionSeries,
                style: TipografiaGyMaster.infoSeriesReps,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Fila con grupo muscular y estado (si están disponibles)
              if (grupoMuscular != null || estadoRutina != null) ...[
                Espaciado.separacionVerticalXs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Grupo muscular
                    if (grupoMuscular != null)
                      Flexible(
                        child: Text(
                          grupoMuscular!,
                          style: TipografiaGyMaster.grupoMuscular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Separación horizontal
                    if (grupoMuscular != null && estadoRutina != null)
                      Espaciado.separacionHorizontalSm,

                    // Estado del ejercicio
                    if (estadoRutina != null)
                      Text(
                        estadoRutina!,
                        style: TipografiaGyMaster.estadoEjercicio,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget reutilizable para mostrar información de ejercicios
/// Sigue reglas de espaciado de 8 puntos y tipografía limitada
class TarjetaEjercicio extends StatelessWidget {
  final String nombreEjercicio;
  final String seriesRepeticiones;
  final String? pesoUtilizado;
  final bool completado;
  final VoidCallback? alTocar;

  const TarjetaEjercicio({
    super.key,
    required this.nombreEjercicio,
    required this.seriesRepeticiones,
    this.pesoUtilizado,
    this.completado = false,
    this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: Espaciado.rellenoVerticalXs,
      child: InkWell(
        onTap: alTocar,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: Espaciado.relleno24y16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: completado ? AppColors.exito.withValues(alpha: 0.1) : null,
          ),
          child: Row(
            children: [
              // Información principal del ejercicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del ejercicio
                    Text(
                      nombreEjercicio,
                      style: TipografiaGyMaster.nombreEjercicio,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Espaciado.separacionVerticalXs,

                    // Series y repeticiones
                    Text(
                      seriesRepeticiones,
                      style: TipografiaGyMaster.infoSeriesReps,
                    ),

                    // Peso utilizado (si está disponible)
                    if (pesoUtilizado != null) ...[
                      Espaciado.separacionVerticalXs,
                      Text(
                        'Peso: $pesoUtilizado',
                        style: TipografiaGyMaster.contadorPesoTiempo,
                      ),
                    ],
                  ],
                ),
              ),

              // Espaciado horizontal
              Espaciado.separacionHorizontalSm,

              // Indicador de estado
              Container(
                width: Espaciado.md,
                height: Espaciado.md,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completado
                      ? AppColors.exito
                      : AppColors.textoDeshabilitado,
                ),
                child: completado
                    ? Icon(
                        Icons.check,
                        size: Espaciado.sm,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar contadores grandes de peso/tiempo
/// Usa tipografía específica para contadores
class ContadorPesoTiempo extends StatelessWidget {
  final String valor;
  final String unidad;
  final String? etiqueta;

  const ContadorPesoTiempo({
    super.key,
    required this.valor,
    required this.unidad,
    this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: AppColors.fondoSecundario,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Etiqueta (si está disponible)
          if (etiqueta != null) ...[
            Text(
              etiqueta!,
              style: TipografiaGyMaster.textoSecundario,
            ),
            Espaciado.separacionVerticalXs,
          ],

          // Contador principal
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                valor,
                style: TipografiaGyMaster.contadorPesoTiempo,
              ),
              Espaciado.separacionHorizontalXs,
              Text(
                unidad,
                style: TipografiaGyMaster.textoPrincipal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar mensajes de estado emocionales
/// Implementa tipografía para diferentes tipos de mensaje
class MensajeEstado extends StatelessWidget {
  final String mensaje;
  final TipoMensaje tipo;
  final IconData? icono;

  const MensajeEstado({
    super.key,
    required this.mensaje,
    required this.tipo,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final estilo = _obtenerEstiloSegunTipo();
    final colorFondo = _obtenerColorFondoSegunTipo();
    final iconoPorDefecto = _obtenerIconoPorDefecto();

    return Container(
      padding: Espaciado.rellenoMd,
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: estilo.color!.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icono ?? iconoPorDefecto,
            color: estilo.color,
            size: Espaciado.md,
          ),
          Espaciado.separacionHorizontalSm,
          Expanded(
            child: Text(
              mensaje,
              style: estilo,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _obtenerEstiloSegunTipo() {
    switch (tipo) {
      case TipoMensaje.exito:
        return TipografiaGyMaster.mensajeExito;
      case TipoMensaje.error:
        return TipografiaGyMaster.mensajeError;
      case TipoMensaje.advertencia:
        return TipografiaGyMaster.mensajeAdvertencia;
      case TipoMensaje.motivacional:
        return TipografiaGyMaster.mensajeMotivacional;
    }
  }

  Color _obtenerColorFondoSegunTipo() {
    switch (tipo) {
      case TipoMensaje.exito:
        return AppColors.exito.withValues(alpha: 0.1);
      case TipoMensaje.error:
        return AppColors.error.withValues(alpha: 0.1);
      case TipoMensaje.advertencia:
        return AppColors.advertencia.withValues(alpha: 0.1);
      case TipoMensaje.motivacional:
        return AppColors.acento.withValues(alpha: 0.1);
    }
  }

  IconData _obtenerIconoPorDefecto() {
    switch (tipo) {
      case TipoMensaje.exito:
        return Icons.check_circle;
      case TipoMensaje.error:
        return Icons.error;
      case TipoMensaje.advertencia:
        return Icons.warning;
      case TipoMensaje.motivacional:
        return Icons.favorite;
    }
  }
}

enum TipoMensaje {
  exito,
  error,
  advertencia,
  motivacional,
}
