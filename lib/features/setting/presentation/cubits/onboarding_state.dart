part of 'onboarding_cubit.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingInitial extends OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingStepChanged extends OnboardingState {
  final int step;

  OnboardingStepChanged(this.step);
}

final class OnboardingMotivationSelected extends OnboardingState {
  final UserMotivation motivation;

  OnboardingMotivationSelected(this.motivation);
}

final class OnboardingMoodSelected extends OnboardingState {
  final UserMood mood;

  OnboardingMoodSelected(this.mood);
}

final class OnboardingCompleted extends OnboardingState {}

final class OnboardingSkipped extends OnboardingState {}

final class OnboardingError extends OnboardingState {
  final String message;

  OnboardingError(this.message);
}
