import 'package:flutter/material.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/create_with_seed_phrase_page.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/another_listtile_widget.dart';

import 'create_wallet_privatekey_page.dart';

class AddExistingWallet extends StatelessWidget {
  const AddExistingWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add existing wallet',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Most popular',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            AnotherListTileWidget(
              onTap: () {
                _showSecretPhraseModal(context);
              },
              title: 'Secret phrase',
              child: Icon(Icons.security),
            ),
            SizedBox(
              height: 10,
            ),
            AnotherListTileWidget(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateWalletWithPrivateKey(),
                  ),
                );
              },
              title: 'Private key',
              child: Icon(Icons.local_activity),
            ),
          ],
        ),
      ),
    );
  }
}

void _showSecretPhraseModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    context: context,
    builder: (context) {
      return SecretPhraseModal();
    },
  );
}

class SecretPhraseModal extends StatefulWidget {
  const SecretPhraseModal({super.key});

  @override
  State<SecretPhraseModal> createState() => _SecretPhraseModalState();
}

class _SecretPhraseModalState extends State<SecretPhraseModal> {
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;

  bool get allChecked => check1 && check2 && check3;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Image.asset(
              'assets/images/seedphrase.png',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Check your secret phrase is safe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 36),
            _buildCheckOption(
              isChecked: check1,
              text: 'Only you know this secret phrase.',
              onChanged: (value) {
                setState(() {
                  check1 = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            _buildCheckOption(
              isChecked: check2,
              text:
                  'This secret phrase was NOT given to you by anyone, e.g. a company representative.',
              onChanged: (value) {
                setState(() {
                  check2 = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            _buildCheckOption(
              isChecked: check3,
              text:
                  'If someone else has seen it, they can and will steal your funds.',
              onChanged: (value) {
                setState(() {
                  check3 = value ?? false;
                });
              },
            ),
            Spacer(),
            ButtonWidget(
              paddng: 18,
              onPressed: allChecked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateWithSeedPhrase(),
                        ),
                      );
                    }
                  : null,
              color: allChecked ? primaryColor : Colors.grey.shade300,
              text: 'Continue',
              textColor: allChecked ? Colors.black : Colors.grey.shade600,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckOption({
    required bool isChecked,
    required String text,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChecked ? Colors.green : Colors.grey[900],
            ),
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.all(
                isChecked ? Colors.green : Colors.grey.shade300,
              ),
              shape: CircleBorder(),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
