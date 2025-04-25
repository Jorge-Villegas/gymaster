part of 'musculo_cubit.dart';

sealed class MusculoState {}

final class MusculoInitial extends MusculoState {}

class MusculoLoaded extends MusculoState {
  final List<Musculo> musculos;
  MusculoLoaded(this.musculos);
}

class MusculoError extends MusculoState {
  final String message;
  MusculoError(this.message);
}

class MusculoLoading extends MusculoState {}
