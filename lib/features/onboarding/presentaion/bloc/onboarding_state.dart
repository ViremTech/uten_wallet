part of 'onboarding_bloc.dart';

abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSeen extends OnboardingState {}

class OnboardingNotSeen extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {}

class OnboardingFailure extends OnboardingState {
  final String errorMessage;

  const OnboardingFailure(this.errorMessage);
}
