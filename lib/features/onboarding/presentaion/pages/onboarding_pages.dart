import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uten_wallet/features/onboarding/domain/entity/onboarding_entity.dart';
import 'package:uten_wallet/features/onboarding/presentaion/pages/last_onboarding_screen.dart';
import 'package:uten_wallet/features/onboarding/presentaion/pages/onboarding_screen.dart';

import '../bloc/onboarding_bloc.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  final int _lastPageIndex = 2;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      final currentPage = _pageController.page?.round() ?? 0;

      if (currentPage == _lastPageIndex) {
        context.read<OnboardingBloc>().add(CompleteOnboarding());
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagesDetails = [
      OnboardingEntity(
        firstButton: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
        secondButton: () {
          _pageController.jumpToPage(2);
          context.read<OnboardingBloc>().add(CompleteOnboarding());
        },
        firstButtonText: 'Continue',
        secondButtonText: 'Skip',
        imagePath: 'assets/images/image1removebg.png',
        caption: 'Trade,send, and store crypto and NFTs',
      ),
      OnboardingEntity(
        firstButton: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          context.read<OnboardingBloc>().add(CompleteOnboarding());
        },
        secondButton: () {
          _pageController.jumpToPage(2);
          context.read<OnboardingBloc>().add(CompleteOnboarding());
        },
        firstButtonText: 'Continue',
        secondButtonText: 'Skip',
        imagePath: 'assets/images/image2removebg.png',
        caption: 'Manage your Dapps',
      ),
    ];
    return PageView(
      controller: _pageController,
      physics: currentIndex == pagesDetails.length
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      children: [
        OnboardingScreen(
          firstButtonText: pagesDetails[0].firstButtonText,
          secondButtonText: pagesDetails[0].secondButtonText,
          caption: pagesDetails[0].caption,
          firstButton: pagesDetails[0].firstButton,
          secondButton: pagesDetails[0].secondButton,
          imagePath: pagesDetails[0].imagePath,
        ),
        OnboardingScreen(
          firstButtonText: pagesDetails[1].firstButtonText,
          secondButtonText: pagesDetails[1].secondButtonText,
          caption: pagesDetails[1].caption,
          firstButton: pagesDetails[1].firstButton,
          secondButton: pagesDetails[1].secondButton,
          imagePath: pagesDetails[1].imagePath,
        ),
        LastOnboardingScreen(),
      ],
    );
  }
}
