import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/presentaion/pages/network_edit_page.dart';
import 'package:uten_wallet/core/widget/snackbar.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallet_home.dart';
import '../../../../features/wallet/presentaion/bloc/update_wallet_network/update_wallet_network_bloc.dart';

class NetworkDetailPage extends StatefulWidget {
  final NetworkEntity network;
  final Function()? onNetworkSelected;

  const NetworkDetailPage({
    super.key,
    required this.network,
    this.onNetworkSelected,
  });

  @override
  State<NetworkDetailPage> createState() => _NetworkDetailPageState();
}

class _NetworkDetailPageState extends State<NetworkDetailPage> {
  bool _snackBarShown = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletNetworkBloc, WalletNetworkState>(
          listener: (context, state) {
            if (state is WalletNetworkUpdated) {
              context.read<GetActiveWalletBloc>().add(LoadActiveWallet());
            }
          },
        ),
        BlocListener<GetActiveWalletBloc, ActiveWalletState>(
          listener: (context, state) {
            if (!_snackBarShown && state is ActiveWalletLoaded) {
              _snackBarShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WalletHome(wallet: state.wallet as WalletModel),
                  ),
                );
                mySnackBar('Network Updated Successfully', context);
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.network.name),
          actions: [
            if (widget.network.isEditable)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          NetworkEditPage(network: widget.network),
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
              _buildNetworkBanner(),
              const SizedBox(height: 24),
              _buildSectionTitle('Network Details'),
              _buildDetailItem('Chain ID', widget.network.chainId.toString()),
              _buildDetailItem(
                  'Currency Symbol', widget.network.currencySymbol),
              _buildDetailItem('Currency Name', widget.network.currencyName),
              _buildDetailItem('Decimals', widget.network.decimals.toString()),
              const SizedBox(height: 24),
              _buildSectionTitle('URLs'),
              ...(widget.network.rpc ?? []).map(
                (rpc) => _buildCopyableItem('RPC URL', rpc),
              ),
              if ((widget.network.blockExplorerUrl ?? '').isNotEmpty)
                _buildCopyableItem(
                    'Block Explorer', widget.network.blockExplorerUrl!),
              const SizedBox(height: 32),
              if (widget.onNetworkSelected != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<WalletNetworkBloc>().add(
                            UpdateWalletNetworkEvent(
                              widget.network.id,
                            ),
                          );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Select This Network'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkBanner() {
    final network = widget.network;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNetworkLogo(),
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
    );
  }

  Widget _buildNetworkLogo() {
    final network = widget.network;
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildDetailItem(String label, String value) {
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

  Widget _buildCopyableItem(String label, String value) {
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
