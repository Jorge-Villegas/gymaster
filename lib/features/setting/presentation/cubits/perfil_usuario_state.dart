import 'package:flutter/material.dart';
import 'package:gymaster/features/setting/data/models/perfil_usuario.dart';

@immutable
sealed class PerfilUsuarioState {}

final class PerfilUsuarioInitial extends PerfilUsuarioState {}

final class PerfilUsuarioLoading extends PerfilUsuarioState {}

final class PerfilUsuarioLoaded extends PerfilUsuarioState {
  final PerfilUsuario perfil;

  PerfilUsuarioLoaded(this.perfil);
}

final class PerfilUsuarioError extends PerfilUsuarioState {
  final String message;

  PerfilUsuarioError(this.message);
}

final class PerfilUsuarioUpdated extends PerfilUsuarioState {
  final PerfilUsuario perfil;

  PerfilUsuarioUpdated(this.perfil);
}
