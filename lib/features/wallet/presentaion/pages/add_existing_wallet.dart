import 'package:flutter/material.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/another_listtile_widget.dart';

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
              'Available Options',
            ),
            SizedBox(
              height: 10,
            ),
            AnotherListTileWidget(
              onTap: () {},
              title: 'Secret phrase',
              child: Icon(Icons.security),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            AnotherListTileWidget(
              onTap: () {},
              title: 'Private key',
              child: Icon(Icons.local_activity),
            ),
          ],
        ),
      ),
    );
  }
}
