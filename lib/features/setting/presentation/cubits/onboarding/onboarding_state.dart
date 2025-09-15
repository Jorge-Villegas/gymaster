import 'package:flutter/foundation.dart';
import 'package:gymaster/features/setting/domain/entities/user_motivation.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingPageChanged extends OnboardingState {
  final int currentPage;
  final UserMotivation partialMotivation;

  OnboardingPageChanged({
    required this.currentPage,
    required this.partialMotivation,
  });
}

final class OnboardingCompleted extends OnboardingState {
  final UserMotivation finalMotivation;

  OnboardingCompleted(this.finalMotivation);
}

final class OnboardingError extends OnboardingState {
  final String message;

  OnboardingError(this.message);
}
