part of 'serie_cubit.dart';

sealed class SerieState {}

final class SerieInitial extends SerieState {}

final class SerieLoading extends SerieState {}

final class SerieError extends SerieState {
  final String message;

  SerieError(this.message);
}

final class SerieAddSuccess extends SerieState {}

final class SerieGetAllSuccess extends SerieState {
  final List<Serie> series;

  SerieGetAllSuccess(this.series);
}
