import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uten_wallet/features/authentication/presentaion/pages/login_page.dart';
import 'package:uten_wallet/features/onboarding/presentaion/pages/last_onboarding_screen.dart';
import 'core/bloc/persist_bloc/persist_bloc.dart';
import 'features/onboarding/presentaion/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentaion/pages/onboarding_pages.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    context.read<PersistBloc>().add(CheckSeedPhraseStatus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersistBloc, PersistState>(
      listener: (context, state) {
        if (state is WalletReady) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
              (route) => false);
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
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
      ),
    );
  }
}
