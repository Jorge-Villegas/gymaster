import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/features/estadisticas/domain/entities/distribucion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/entities/periodo_tiempo.dart';
import 'package:gymaster/features/estadisticas/domain/entities/ranking_ejercicio.dart';
import 'package:gymaster/features/estadisticas/domain/entities/recomendacion_muscular.dart';
import 'package:gymaster/features/estadisticas/domain/usecases/obtener_distribucion_muscular_usecase.dart';
import 'package:gymaster/features/estadisticas/domain/usecases/obtener_musculos_olvidados_usecase.dart';
import 'package:gymaster/features/estadisticas/domain/usecases/obtener_ranking_ejercicios_usecase.dart';
import 'package:gymaster/features/estadisticas/domain/usecases/obtener_resumen_general_usecase.dart';
import 'package:gymaster/features/estadisticas/presentation/cubits/estadisticas_state.dart';

/// Cubit para gestionar el estado de las estadísticas de entrenamiento.
///
/// Coordina la carga de datos desde múltiples UseCases y maneja
/// el cambio de periodos de tiempo con recarga automática.
class EstadisticasCubit extends Cubit<EstadisticasState> {
  final ObtenerDistribucionMuscularUseCase _obtenerDistribucionMuscularUseCase;
  final ObtenerRankingEjerciciosUseCase _obtenerRankingEjerciciosUseCase;
  final ObtenerMusculosOlvidadosUseCase _obtenerMusculosOlvidadosUseCase;
  final ObtenerResumenGeneralUseCase _obtenerResumenGeneralUseCase;

  EstadisticasCubit({
    required ObtenerDistribucionMuscularUseCase
        obtenerDistribucionMuscularUseCase,
    required ObtenerRankingEjerciciosUseCase obtenerRankingEjerciciosUseCase,
    required ObtenerMusculosOlvidadosUseCase obtenerMusculosOlvidadosUseCase,
    required ObtenerResumenGeneralUseCase obtenerResumenGeneralUseCase,
  })  : _obtenerDistribucionMuscularUseCase =
            obtenerDistribucionMuscularUseCase,
        _obtenerRankingEjerciciosUseCase = obtenerRankingEjerciciosUseCase,
        _obtenerMusculosOlvidadosUseCase = obtenerMusculosOlvidadosUseCase,
        _obtenerResumenGeneralUseCase = obtenerResumenGeneralUseCase,
        super(EstadisticasInitial()) {
    // Cargar estadísticas por defecto (última semana)
    cargarEstadisticas(PeriodoTiempo.semanaActual);
  }

  /// Carga todas las estadísticas para el periodo seleccionado.
  ///
  /// [periodo] Periodo de tiempo a analizar
  /// [rangoPersonalizado] Rango de fechas si periodo == rangoPersonalizado
  Future<void> cargarEstadisticas(
    PeriodoTiempo periodo, {
    (DateTime, DateTime)? rangoPersonalizado,
  }) async {
    emit(EstadisticasLoading());

    try {
      // Obtener rango de fechas según el periodo
      final (fechaInicio, fechaFin) = _obtenerRangoFechas(
        periodo,
        rangoPersonalizado,
      );

      // Ejecutar todos los UseCases en paralelo para optimizar performance
      final resultados = await Future.wait([
        _obtenerDistribucionMuscularUseCase(
          ObtenerDistribucionMuscularParams(
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
          ),
        ),
        _obtenerRankingEjerciciosUseCase(
          ObtenerRankingEjerciciosParams(
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            limite: 10,
          ),
        ),
        _obtenerMusculosOlvidadosUseCase(
          ObtenerMusculosOlvidadosParams(diasLimite: 7),
        ),
        _obtenerResumenGeneralUseCase(
          ObtenerResumenGeneralParams(
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
          ),
        ),
      ]);

      // Validar resultados
      final distribucionResult = resultados[0];
      final rankingResult = resultados[1];
      final musculosOlvidadosResult = resultados[2];
      final resumenResult = resultados[3];

      // Manejar errores de cada UseCase
      distribucionResult.fold(
        (failure) {
          emit(EstadisticasError(
            _obtenerMensajeUsuario(failure.errorMessage),
          ));
          return;
        },
        (_) {},
      );

      if (state is EstadisticasError) return;

      rankingResult.fold(
        (failure) {
          emit(EstadisticasError(
            _obtenerMensajeUsuario(failure.errorMessage),
          ));
          return;
        },
        (_) {},
      );

      if (state is EstadisticasError) return;

      resumenResult.fold(
        (failure) {
          emit(EstadisticasError(
            _obtenerMensajeUsuario(failure.errorMessage),
          ));
          return;
        },
        (_) {},
      );

      if (state is EstadisticasError) return;

      // Extraer datos exitosos usando fold con tipos explícitos
      final distribucion = distribucionResult.fold<List<DistribucionMuscular>>(
        (_) => <DistribucionMuscular>[],
        (data) => data as List<DistribucionMuscular>,
      );
      final ranking = rankingResult.fold<List<RankingEjercicio>>(
        (_) => <RankingEjercicio>[],
        (data) => data as List<RankingEjercicio>,
      );
      final musculosOlvidados =
          musculosOlvidadosResult.fold<List<RecomendacionMuscular>>(
        (_) => <RecomendacionMuscular>[],
        (data) => data as List<RecomendacionMuscular>,
      );
      final resumen = resumenResult.fold<Map<String, dynamic>>(
        (_) => <String, dynamic>{},
        (data) => data as Map<String, dynamic>,
      );

      // Verificar si hay datos
      if (distribucion.isEmpty && ranking.isEmpty) {
        emit(EstadisticasEmpty(
          'No hay datos de entrenamientos en ${periodo.etiqueta.toLowerCase()}.\n'
          '¡Comienza tu primera sesión!',
        ));
        return;
      }

      // Emitir estado exitoso
      emit(EstadisticasLoaded(
        periodoSeleccionado: periodo,
        rangoPersonalizado: rangoPersonalizado,
        distribucionMuscular: distribucion,
        rankingEjercicios: ranking,
        musculosOlvidados: musculosOlvidados,
        resumenGeneral: resumen,
      ));

      debugPrint(
        '✅ [EstadisticasCubit] Estadísticas cargadas: '
        '${distribucion.length} músculos, '
        '${ranking.length} ejercicios, '
        '${musculosOlvidados.length} recomendaciones',
      );
    } catch (e) {
      debugPrint('❌ [EstadisticasCubit] Error inesperado: $e');
      emit(EstadisticasError(
        'Error inesperado al cargar estadísticas. Intenta de nuevo.',
      ));
    }
  }

  /// Cambia el periodo seleccionado y recarga los datos.
  Future<void> cambiarPeriodo(
    PeriodoTiempo nuevoPeriodo, {
    (DateTime, DateTime)? rangoPersonalizado,
  }) async {
    await cargarEstadisticas(nuevoPeriodo,
        rangoPersonalizado: rangoPersonalizado);
  }

  /// Recarga las estadísticas con el periodo actual.
  Future<void> recargarEstadisticas() async {
    if (state is EstadisticasLoaded) {
      final estadoActual = state as EstadisticasLoaded;
      await cargarEstadisticas(
        estadoActual.periodoSeleccionado,
        rangoPersonalizado: estadoActual.rangoPersonalizado,
      );
    } else {
      // Si no hay estado previo, cargar semana actual
      await cargarEstadisticas(PeriodoTiempo.semanaActual);
    }
  }

  /// Obtiene el rango de fechas según el periodo seleccionado.
  (DateTime, DateTime) _obtenerRangoFechas(
    PeriodoTiempo periodo,
    (DateTime, DateTime)? rangoPersonalizado,
  ) {
    if (periodo == PeriodoTiempo.rangoPersonalizado) {
      if (rangoPersonalizado == null) {
        throw ArgumentError(
          'Se debe proporcionar rangoPersonalizado cuando periodo == rangoPersonalizado',
        );
      }
      return rangoPersonalizado;
    }

    final rango = periodo.obtenerRangoFechas();
    if (rango == null) {
      throw StateError('No se pudo obtener rango de fechas para $periodo');
    }

    return rango;
  }

  /// Convierte mensajes de error técnicos en mensajes amigables para el usuario.
  String _obtenerMensajeUsuario(String errorMessage) {
    if (errorMessage.toLowerCase().contains('database')) {
      return 'Error de base de datos. Intenta cerrar y abrir la app.';
    }
    if (errorMessage.toLowerCase().contains('no hay datos') ||
        errorMessage.toLowerCase().contains('no records')) {
      return 'No hay datos de entrenamientos en este periodo.';
    }
    if (errorMessage.toLowerCase().contains('ejercicio no encontrado')) {
      return 'El ejercicio seleccionado no existe.';
    }
    return 'Ocurrió un error inesperado. Por favor intenta de nuevo.';
  }
}
