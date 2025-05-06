abstract class OnboardingRepository {
  Future<void> setLastScreen();
  Future<bool> hasSeenOnboarding();
}
