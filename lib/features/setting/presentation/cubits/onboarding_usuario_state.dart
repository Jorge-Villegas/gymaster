import 'package:flutter/material.dart';
import 'package:gymaster/features/setting/domain/entities/perfil_usuario_completo.dart';

@immutable
sealed class OnboardingUsuarioState {}

final class OnboardingUsuarioInitial extends OnboardingUsuarioState {}

final class OnboardingUsuarioLoading extends OnboardingUsuarioState {}

final class OnboardingUsuarioVerificando extends OnboardingUsuarioState {}

final class OnboardingUsuarioNecesario extends OnboardingUsuarioState {}

final class OnboardingUsuarioCompleto extends OnboardingUsuarioState {
  final String mensaje;
  OnboardingUsuarioCompleto(this.mensaje);
}

final class OnboardingUsuarioCreandoPerfil extends OnboardingUsuarioState {}

final class OnboardingUsuarioPerfilCreado extends OnboardingUsuarioState {
  final String mensaje;
  OnboardingUsuarioPerfilCreado(this.mensaje);
}

final class OnboardingUsuarioPerfilCargado extends OnboardingUsuarioState {
  final PerfilUsuarioCompleto perfil;
  OnboardingUsuarioPerfilCargado(this.perfil);
}

final class OnboardingUsuarioError extends OnboardingUsuarioState {
  final String mensaje;
  OnboardingUsuarioError(this.mensaje);
}
