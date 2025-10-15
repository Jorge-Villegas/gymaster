import 'package:flutter/material.dart';
import 'package:gymaster/features/setting/data/models/configuracion_usuario.dart';

@immutable
sealed class ConfiguracionUsuarioState {}

final class ConfiguracionUsuarioInitial extends ConfiguracionUsuarioState {}

final class ConfiguracionUsuarioLoading extends ConfiguracionUsuarioState {}

final class ConfiguracionUsuarioLoaded extends ConfiguracionUsuarioState {
  final ConfiguracionUsuario configuracion;

  ConfiguracionUsuarioLoaded(this.configuracion);
}

final class ConfiguracionUsuarioError extends ConfiguracionUsuarioState {
  final String message;

  ConfiguracionUsuarioError(this.message);
}

final class ConfiguracionUsuarioCreated extends ConfiguracionUsuarioState {
  final ConfiguracionUsuario configuracion;

  ConfiguracionUsuarioCreated(this.configuracion);
}

final class ConfiguracionUsuarioUpdated extends ConfiguracionUsuarioState {
  final ConfiguracionUsuario configuracion;

  ConfiguracionUsuarioUpdated(this.configuracion);
}
