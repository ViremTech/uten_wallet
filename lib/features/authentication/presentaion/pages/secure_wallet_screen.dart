import 'package:flutter/material.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/secure_wallet.dart';

import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';

import '../../../../core/constant/constant.dart';

class SecureWalletScreen extends StatelessWidget {
  const SecureWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Secure Your Wallet',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/image4.png',
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    "Don't risk losing your funds. protect your wallet by saving your Seed Phrase in a place you trust.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Text(
                    "It's the only way to recover your wallet if you get locked out of the app or get a new device.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ButtonWidget(
                  paddng: 16,
                  onPressed: () {},
                  color: Colors.transparent,
                  text: 'Remind Me Later',
                  textColor: Colors.white,
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ButtonWidget(
                    paddng: 16,
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                    color: Colors.white,
                    text: 'Next',
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _showModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.7,
        child: Container(
          padding: EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "What is a 'Seed phrase'",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '''
A seed phrase is a set of twelve words that contains all the information about your wallet, including your funds. It's like a secret code used to access your entire wallet.
          
You must keep your seed phrase secret and safe. If someone gets your seed phrase, they'll gain control over your accounts.
          
Save it in a place where only you can access it. If you lose it, not even Cryptooly can help you recover it.    
                ''',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
              ),
              SizedBox(
                height: 10,
              ),
              ButtonWidget(
                  paddng: 16,
                  textColor: Colors.black,
                  color: Colors.white,
                  text: 'I Got It',
                  onPressed: () {
                    Navigator.pop(context);
                    _showModalBottomSheetNew(context);
                  })
            ],
          ),
        ),
      );
    },
  );
}

void _showModalBottomSheetNew(BuildContext context) {
  bool _value = false;
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
              padding: EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skip Account Security?',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _value,
                        onChanged: (value) {
                          value = !_value;
                        },
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Flexible(
                        child: Text(
                          'I understand that if i lose my seed phrase i will not be able to access my wallet',
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 160,
                        child: ButtonWidget(
                          paddng: 0,
                          textColor: Colors.black,
                          color: Colors.white,
                          text: 'Secure Now',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SecureWalletDetail(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 60,
                        width: 160,
                        child: ButtonWidget(
                          paddng: 0,
                          textColor: Colors.white,
                          text: 'Skip',
                          onPressed: () {},
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                ],
              )),
        );
      });
}
