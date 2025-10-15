part of 'app_start_cubit.dart';

@immutable
sealed class AppStartState {}

final class AppStartInitial extends AppStartState {}

final class AppStartLoading extends AppStartState {}

final class AppStartShowOnboarding extends AppStartState {}

final class AppStartShowMainApp extends AppStartState {}

final class AppStartError extends AppStartState {
  final String message;

  AppStartError(this.message);
}
