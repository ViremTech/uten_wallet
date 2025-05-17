// features/token/presentation/pages/token_details_page.dart
import 'package:flutter/material.dart';

import '../../domain/entity/token_entity.dart';

class TokenDetailsPage extends StatelessWidget {
  final TokenEntity token;

  const TokenDetailsPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${token.name} (${token.symbol})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(token.logoURI),
                child: token.logoURI.isEmpty
                    ? const Icon(Icons.currency_bitcoin, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text('Balance: ${token.balance}'),
            const SizedBox(height: 10),
            Text('Contract: ${token.contractAddress}'),
            const SizedBox(height: 10),
            Text('Chain ID: ${token.chainId}'),
            const SizedBox(height: 10),
            Text('Decimals: ${token.decimals}'),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(context, Icons.send, 'Send'),
                _buildActionButton(context, Icons.call_received, 'Receive'),
                _buildActionButton(context, Icons.swap_horiz, 'Swap'),
                _buildActionButton(context, Icons.shopping_bag, 'Buy'),
                _buildActionButton(context, Icons.sell, 'Sell'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: () {
            // Implement action
          },
        ),
        Text(label),
      ],
    );
  }
}
