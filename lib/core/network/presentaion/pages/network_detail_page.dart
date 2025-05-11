// lib/core/network/presentaion/pages/network_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/presentaion/pages/network_edit_page.dart';

class NetworkDetailPage extends StatelessWidget {
  final NetworkEntity network;
  final Function()? onNetworkSelected;

  const NetworkDetailPage({
    Key? key,
    required this.network,
    this.onNetworkSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(network.name),
        actions: [
          if (network.isEditable)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NetworkEditPage(network: network),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network banner section
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildNetworkLogo(context),
                    const SizedBox(height: 16),
                    Text(
                      network.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      network.shortName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (network.isTestnet)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Chip(
                          label: const Text('Testnet'),
                          backgroundColor: Colors.orange.withOpacity(0.2),
                          labelStyle: const TextStyle(color: Colors.orange),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Technical details section
            Text(
              'Network Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            _buildDetailItem(context, 'Chain ID', network.chainId.toString()),
            _buildDetailItem(
                context, 'Currency Symbol', network.currencySymbol),
            _buildDetailItem(context, 'Currency Name', network.currencyName),
            _buildDetailItem(context, 'Decimals', network.decimals.toString()),

            const SizedBox(height: 24),

            // URLs section
            Text(
              'URLs',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            if (network.rpc.isNotEmpty)
              for (var rpc in network.rpc)
                _buildCopyableItem(context, 'RPC URL', rpc),

            if (network.blockExplorerUrl.isNotEmpty)
              _buildCopyableItem(
                  context, 'Block Explorer', network.blockExplorerUrl),

            const SizedBox(height: 32),

            // Select network button
            if (onNetworkSelected != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNetworkSelected,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Select This Network'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkLogo(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: network.isTestnet
            ? Colors.orange.withOpacity(0.2)
            : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          network.shortName.isNotEmpty
              ? network.shortName.substring(0, 1).toUpperCase()
              : 'N',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: network.isTestnet ? Colors.orange : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$label copied to clipboard')),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
