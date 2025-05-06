import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/confirm_seedphrase.dart';

import '../../../onboarding/presentaion/widget/button_widget.dart';

class CreateSeedphraseScreen extends StatefulWidget {
  final String mnemonic;
  const CreateSeedphraseScreen({super.key, required this.mnemonic});

  @override
  State<CreateSeedphraseScreen> createState() => _CreateSeedphraseScreenState();
}

class _CreateSeedphraseScreenState extends State<CreateSeedphraseScreen> {
  late String mnemonicPhrase;

  @override
  void initState() {
    mnemonicPhrase = widget.mnemonic;
    super.initState();
  }

  bool _showSeed = true;

  void _revealSeed() {
    setState(() {
      _showSeed = !_showSeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seedPhrase = mnemonicPhrase.split(' ');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Secure Your Wallet'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This is your seed phrase. Write it down on a paper and keep it in a safe place. You'll be asked to re-enter this phrase (in order) on the next step.",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: primaryColor,
                            width: 1,
                          ),
                        ),
                        width: double.infinity,
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: seedPhrase.length,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2.5,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                child: Text(
                                  seedPhrase[index],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_showSeed)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: _revealSeed,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                                child: Container(
                                  color: Color.fromRGBO(255, 255, 255, 0.2),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        'Tap to reveal your seed phrase',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Make sure no one is watching your screen.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ButtonWidget(
                  color: Colors.white,
                  text: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmSeed(
                          correctSeed: seedPhrase,
                        ),
                      ),
                    );
                  },
                  paddng: 16,
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
