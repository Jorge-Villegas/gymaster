import 'package:flutter/foundation.dart';
import 'package:gymaster/features/exercise/domain/entities/exercise.dart';

/// Estados del Cubit de ejercicios favoritos
/// Usa sealed classes para garantizar exhaustividad en pattern matching
@immutable
sealed class FavoritoEjercicioState {}

/// Estado inicial del cubit
final class FavoritoEjercicioInitial extends FavoritoEjercicioState {}

/// Estado de carga para cualquier operación
final class FavoritoEjercicioLoading extends FavoritoEjercicioState {}

/// Estado exitoso al agregar un ejercicio a favoritos
final class FavoritoEjercicioAgregarSuccess extends FavoritoEjercicioState {
  final String ejercicioId;
  final String mensaje;

  FavoritoEjercicioAgregarSuccess({
    required this.ejercicioId,
    required this.mensaje,
  });
}

/// Estado exitoso al remover un ejercicio de favoritos
final class FavoritoEjercicioRemoverSuccess extends FavoritoEjercicioState {
  final String ejercicioId;
  final String mensaje;

  FavoritoEjercicioRemoverSuccess({
    required this.ejercicioId,
    required this.mensaje,
  });
}

/// Estado con la verificación de si un ejercicio es favorito
final class FavoritoEjercicioVerificarSuccess extends FavoritoEjercicioState {
  final String ejercicioId;
  final bool esFavorito;

  FavoritoEjercicioVerificarSuccess({
    required this.ejercicioId,
    required this.esFavorito,
  });
}

/// Estado exitoso al obtener todos los ejercicios favoritos
final class FavoritoEjercicioObtenerTodosSuccess
    extends FavoritoEjercicioState {
  final List<Exercise> ejerciciosFavoritos;

  FavoritoEjercicioObtenerTodosSuccess(this.ejerciciosFavoritos);
}

/// Estado de error para cualquier operación fallida
final class FavoritoEjercicioError extends FavoritoEjercicioState {
  final String mensaje;

  FavoritoEjercicioError(this.mensaje);
}
