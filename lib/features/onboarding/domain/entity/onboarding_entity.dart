class OnboardingEntity {
  final void Function()? firstButton;
  final void Function()? secondButton;
  final String firstButtonText;
  final String secondButtonText;
  final String imagePath;
  final String caption;

  OnboardingEntity(
      {required this.firstButton,
      required this.secondButton,
      required this.firstButtonText,
      required this.secondButtonText,
      required this.imagePath,
      required this.caption});
}
