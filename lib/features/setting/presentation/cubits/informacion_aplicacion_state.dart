import 'package:flutter/foundation.dart';
import 'package:gymaster/features/setting/data/models/informacion_aplicacion.dart';

@immutable
sealed class InformacionAplicacionState {}

final class InformacionAplicacionInitial extends InformacionAplicacionState {}

final class InformacionAplicacionLoading extends InformacionAplicacionState {}

final class InformacionAplicacionLoaded extends InformacionAplicacionState {
  final InformacionAplicacion informacion;

  InformacionAplicacionLoaded(this.informacion);
}

final class InformacionAplicacionError extends InformacionAplicacionState {
  final String message;

  InformacionAplicacionError(this.message);
}

final class InformacionAplicacionUpdated extends InformacionAplicacionState {
  final InformacionAplicacion informacion;

  InformacionAplicacionUpdated(this.informacion);
}
