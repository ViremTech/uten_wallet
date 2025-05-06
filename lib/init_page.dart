import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/onboarding/presentaion/pages/last_onboarding_screen.dart';
import 'features/onboarding/presentaion/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentaion/pages/onboarding_pages.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is OnboardingFailure) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.errorMessage}')),
          );
        } else if (state is OnboardingNotSeen) {
          return OnboardingPages();
        } else {
          return const Scaffold(
            body: LastOnboardingScreen(),
          );
        }
      },
    );
  }
}
