import 'package:flutter/material.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/import_wallet.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';

import '../../../authentication/presentaion/pages/create_password_screen.dart';

class LastOnboardingScreen extends StatelessWidget {
  const LastOnboardingScreen({
    super.key,
  });

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
            'assets/images/image3removebg.png',
            height: 500,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  'Manage everything in Uten wallet',
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatePasswordScreen()));
                },
                textColor: Colors.black,
                color: Colors.white,
                text: 'Create new wallet',
              ),
              SizedBox(
                height: 5,
              ),
              ButtonWidget(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ImportWallet()));
                },
                textColor: Colors.white,
                color: Colors.transparent,
                text: 'I already have a wallet',
                paddng: 16,
              )
            ],
          ),
        ],
      ),
    );
  }
}
