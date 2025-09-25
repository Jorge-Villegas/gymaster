import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymaster/core/usecase/usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/agregar_ejercicio_a_favoritos_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/remover_ejercicio_de_favoritos_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/verificar_ejercicio_favorito_usecase.dart';
import 'package:gymaster/features/exercise/domain/usecases/obtener_ejercicios_favoritos_usecase.dart';
import 'package:gymaster/features/exercise/presentation/cubits/favorito_ejercicio_state.dart';

/// Cubit para manejar el estado de ejercicios favoritos
/// Sigue el patrón CQRS separando comandos de consultas para mejor organizacion
class FavoritoEjercicioCubit extends Cubit<FavoritoEjercicioState> {
  final AgregarEjercicioAFavoritosUseCase agregarEjercicioAFavoritosUseCase;
  final RemoverEjercicioDeFavoritosUseCase removerEjercicioDeFavoritosUseCase;
  final VerificarEjercicioFavoritoUseCase verificarEjercicioFavoritoUseCase;
  final ObtenerEjerciciosFavoritosUseCase obtenerEjerciciosFavoritosUseCase;

  // Cache local para mejorar performance y reducir llamadas a BD
  final Set<String> _favoritosCache = <String>{};
  bool _cacheInicializado = false;

  FavoritoEjercicioCubit({
    required this.agregarEjercicioAFavoritosUseCase,
    required this.removerEjercicioDeFavoritosUseCase,
    required this.verificarEjercicioFavoritoUseCase,
    required this.obtenerEjerciciosFavoritosUseCase,
  }) : super(FavoritoEjercicioInitial()) {
    // Inicializar cache al crear el cubit
    _inicializarCacheFavoritos();
  }

  // === COMANDOS (MODIFICACIONES) ===

  /// Agregar un ejercicio a favoritos
  /// Actualiza cache local para reflejar cambios inmediatamente en UI
  Future<void> agregarEjercicioAFavoritos(String ejercicioId) async {
    emit(FavoritoEjercicioLoading());

    try {
      final params = AgregarEjercicioAFavoritosParams(ejercicioId: ejercicioId);
      final result = await agregarEjercicioAFavoritosUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error al agregar a favoritos: ${failure.errorMessage}');
          emit(FavoritoEjercicioError(
              _mensajeAmigableError(failure.errorMessage)));
        },
        (favorito) {
          // Actualizar cache local
          _favoritosCache.add(ejercicioId);

          emit(FavoritoEjercicioAgregarSuccess(
            ejercicioId: ejercicioId,
            mensaje: '¡Ejercicio agregado a favoritos!',
          ));
        },
      );
    } catch (e) {
      debugPrint('Error inesperado al agregar a favoritos: $e');
      emit(FavoritoEjercicioError('Error inesperado. Intenta de nuevo.'));
    }
  }

  /// Remover un ejercicio de favoritos
  /// Actualiza cache local para reflejar cambios inmediatamente en UI
  Future<void> removerEjercicioDeFavoritos(String ejercicioId) async {
    emit(FavoritoEjercicioLoading());

    try {
      final params =
          RemoverEjercicioDeFavoritosParams(ejercicioId: ejercicioId);
      final result = await removerEjercicioDeFavoritosUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error al remover de favoritos: ${failure.errorMessage}');
          emit(FavoritoEjercicioError(
              _mensajeAmigableError(failure.errorMessage)));
        },
        (removido) {
          if (removido) {
            // Actualizar cache local
            _favoritosCache.remove(ejercicioId);

            emit(FavoritoEjercicioRemoverSuccess(
              ejercicioId: ejercicioId,
              mensaje: 'Ejercicio removido de favoritos',
            ));
          } else {
            emit(FavoritoEjercicioError('El ejercicio no estaba en favoritos'));
          }
        },
      );
    } catch (e) {
      debugPrint('Error inesperado al remover de favoritos: $e');
      emit(FavoritoEjercicioError('Error inesperado. Intenta de nuevo.'));
    }
  }

  // === CONSULTAS (SOLO LECTURA) ===

  /// Verificar si un ejercicio específico está en favoritos
  /// Usa cache local si está disponible para mejor performance
  Future<void> verificarEjercicioFavorito(String ejercicioId) async {
    try {
      // Si el cache está inicializado, usar respuesta inmediata
      if (_cacheInicializado) {
        final esFavorito = _favoritosCache.contains(ejercicioId);
        emit(FavoritoEjercicioVerificarSuccess(
          ejercicioId: ejercicioId,
          esFavorito: esFavorito,
        ));
        return;
      }

      // Si no hay cache, consultar BD
      emit(FavoritoEjercicioLoading());

      final params = VerificarEjercicioFavoritoParams(ejercicioId: ejercicioId);
      final result = await verificarEjercicioFavoritoUseCase(params);

      result.fold(
        (failure) {
          debugPrint('Error al verificar favorito: ${failure.errorMessage}');
          emit(FavoritoEjercicioError(
              _mensajeAmigableError(failure.errorMessage)));
        },
        (esFavorito) {
          // Actualizar cache con el resultado
          if (esFavorito) {
            _favoritosCache.add(ejercicioId);
          }

          emit(FavoritoEjercicioVerificarSuccess(
            ejercicioId: ejercicioId,
            esFavorito: esFavorito,
          ));
        },
      );
    } catch (e) {
      debugPrint('Error inesperado al verificar favorito: $e');
      emit(FavoritoEjercicioError('Error al verificar favorito'));
    }
  }

  /// Obtener todos los ejercicios favoritos con sus datos completos
  /// Para mostrar en página de favoritos o listas especiales
  Future<void> obtenerTodosLosEjerciciosFavoritos() async {
    emit(FavoritoEjercicioLoading());

    try {
      final result = await obtenerEjerciciosFavoritosUseCase(NoParams());

      result.fold(
        (failure) {
          debugPrint(
              'Error al obtener ejercicios favoritos: ${failure.errorMessage}');
          emit(FavoritoEjercicioError(
              _mensajeAmigableError(failure.errorMessage)));
        },
        (ejerciciosFavoritos) {
          // Actualizar cache con los IDs de ejercicios obtenidos
          _favoritosCache.clear();
          _favoritosCache.addAll(ejerciciosFavoritos.map((e) => e.id));
          _cacheInicializado = true;

          emit(FavoritoEjercicioObtenerTodosSuccess(ejerciciosFavoritos));
        },
      );
    } catch (e) {
      debugPrint('Error inesperado al obtener ejercicios favoritos: $e');
      emit(FavoritoEjercicioError('Error al cargar favoritos'));
    }
  }

  // === MÉTODOS DE UTILIDAD ===

  /// Verificación sincróna de favorito usando cache local
  /// Útil para actualizar UI inmediatamente sin esperar BD
  bool esEjercicioFavoritoSync(String ejercicioId) {
    return _cacheInicializado ? _favoritosCache.contains(ejercicioId) : false;
  }

  /// Toggle favorito - agrega si no está, remueve si está
  /// Operación combinada para botones de corazón
  Future<void> toggleFavorito(String ejercicioId) async {
    if (esEjercicioFavoritoSync(ejercicioId)) {
      await removerEjercicioDeFavoritos(ejercicioId);
    } else {
      await agregarEjercicioAFavoritos(ejercicioId);
    }
  }

  /// Obtener cantidad de favoritos desde cache
  /// Para badges y estadísticas rápidas
  int get cantidadFavoritos => _favoritosCache.length;

  /// Resetear cubit a estado inicial
  /// Útil para limpiar estado al cambiar de usuario
  void resetear() {
    _favoritosCache.clear();
    _cacheInicializado = false;
    emit(FavoritoEjercicioInitial());
  }

  // === MÉTODOS PRIVADOS ===

  /// Inicializar cache de favoritos al crear el cubit
  /// Carga silenciosa para tener datos disponibles inmediatamente
  Future<void> _inicializarCacheFavoritos() async {
    try {
      final result = await obtenerEjerciciosFavoritosUseCase(NoParams());
      result.fold(
        (failure) {
          // Log error silenciosamente, no afectar UI inicial
          debugPrint(
              'No se pudo inicializar cache de favoritos: ${failure.errorMessage}');
        },
        (ejerciciosFavoritos) {
          _favoritosCache.clear();
          _favoritosCache.addAll(ejerciciosFavoritos.map((e) => e.id));
          _cacheInicializado = true;
        },
      );
    } catch (e) {
      debugPrint('Error al inicializar cache de favoritos: $e');
    }
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _mensajeAmigableError(String errorTecnico) {
    if (errorTecnico.toLowerCase().contains('database')) {
      return 'Error de almacenamiento. Intenta de nuevo.';
    }
    if (errorTecnico.toLowerCase().contains('no records') ||
        errorTecnico.toLowerCase().contains('no tienes')) {
      return 'No tienes ejercicios favoritos aún.';
    }
    if (errorTecnico.toLowerCase().contains('ya está')) {
      return 'Este ejercicio ya está en tus favoritos.';
    }

    return 'Ocurrió un error. Intenta de nuevo.';
  }
}
