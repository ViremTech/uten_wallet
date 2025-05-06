import 'package:flutter/material.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';

class OnboardingScreen extends StatelessWidget {
  final void Function()? firstButton;
  final void Function()? secondButton;
  final String firstButtonText;
  final String secondButtonText;
  final String imagePath;
  final String caption;
  const OnboardingScreen(
      {super.key,
      required this.firstButtonText,
      required this.secondButtonText,
      required this.caption,
      required this.firstButton,
      required this.secondButton,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            imagePath,
            height: 450,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  caption,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                        color: Colors.white,
                        fontSize: 24,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ButtonWidget(
                paddng: 16,
                onPressed: firstButton,
                textColor: Colors.black,
                color: Colors.white,
                text: firstButtonText,
              ),
              SizedBox(
                height: 5,
              ),
              ButtonWidget(
                onPressed: secondButton,
                textColor: Colors.white,
                color: Colors.transparent,
                text: secondButtonText,
                paddng: 16,
              )
            ],
          ),
        ],
      ),
    );
  }
}
