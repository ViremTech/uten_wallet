import 'package:flutter/material.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';

import '../../../../core/constant/constant.dart';

class CreateNewWalletScreen extends StatelessWidget {
  const CreateNewWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(7),
              child: ListTile(
                  leading: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                      color: primaryColor,
                      border: Border.all(
                        width: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    child: Icon(Icons.security),
                  ),
                  title: Text('Seed Phrase'),
                  trailing: SizedBox(
                    width: 110,
                    child: ButtonWidget(
                        paddng: 0,
                        onPressed: () {},
                        color: primaryColor,
                        text: 'Create',
                        textColor: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
