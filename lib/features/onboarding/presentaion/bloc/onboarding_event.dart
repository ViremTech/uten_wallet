part of 'onboarding_bloc.dart';

@immutable
abstract class OnboardingEvent {}

class CheckIfSeenOnboarding extends OnboardingEvent {}

class CompleteOnboarding extends OnboardingEvent {}
