// lib/core/network/presentaion/pages/network_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/presentaion/bloc/evmchain_bloc.dart';
import 'package:uten_wallet/core/network/presentaion/pages/network_edit_page.dart';

import 'network_detail_page.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  final TextEditingController _searchController = TextEditingController();
  List<NetworkEntity> _filteredNetworks = [];
  List<NetworkEntity> _allNetworks = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Trigger loading of EVM chains when the page is opened
    context.read<EvmChainBloc>().add(LoadEvmChainsEvent());
    _searchController.addListener(_filterNetworks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterNetworks);
    _searchController.dispose();
    super.dispose();
  }

  void _filterNetworks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredNetworks = _allNetworks;
      } else {
        _filteredNetworks = _allNetworks.where((network) {
          return network.name.toLowerCase().contains(query) ||
              network.shortName.toLowerCase().contains(query) ||
              network.chainId.toString().contains(query);
        }).toList();
      }
    });
  }

  void _navigateToEditPage(NetworkEntity? network) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NetworkEditPage(network: network),
      ),
    );
    // Refresh the networks list when returning from edit page
    context.read<EvmChainBloc>().add(LoadEvmChainsEvent());
  }

  void _deleteNetwork(String networkId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Network'),
        content: const Text(
            'Are you sure you want to delete this network? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<EvmChainBloc>().add(DeleteNetworkEvent(networkId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EVM Networks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToEditPage(null),
            tooltip: 'Add Network',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: BlocConsumer<EvmChainBloc, EvmChainState>(
              listener: (context, state) {
                if (state is EvmChainLoadedState) {
                  setState(() {
                    _allNetworks = state.chains;
                    _filteredNetworks = state.chains;
                  });
                } else if (state is NetworkOperationSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  // Reload networks after successful operation
                  context.read<EvmChainBloc>().add(LoadEvmChainsEvent());
                } else if (state is EvmChainErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is EvmChainLoadingState && _allNetworks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EvmChainErrorState &&
                    _allNetworks.isEmpty) {
                  return _buildErrorView(state.message);
                } else {
                  return _buildNetworksList();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search networks...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworksList() {
    if (_filteredNetworks.isEmpty && _allNetworks.isEmpty) {
      return const Center(child: Text('No networks available'));
    }

    if (_filteredNetworks.isEmpty) {
      return const Center(
          child: Text('No networks found matching your search'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: _filteredNetworks.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final network = _filteredNetworks[index];
        return _buildNetworkItem(network);
      },
    );
  }

  Widget _buildNetworkItem(NetworkEntity network) {
    return Dismissible(
      key: Key(network.id),
      // Only allow dismissing if the network is editable (custom network)
      direction: network.isEditable
          ? DismissDirection.endToStart
          : DismissDirection.none,
      confirmDismiss: (direction) async {
        // Show delete confirmation
        if (direction == DismissDirection.endToStart) {
          _deleteNetwork(network.id);
          return false; // We'll handle deletion ourselves
        }
        return false;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: _buildNetworkIcon(network),
        title: Text(
          network.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chain ID: ${network.chainId}'),
            if (network.rpc.isNotEmpty)
              Text(
                'RPC: ${network.rpc.first}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            // Indicate if the network is a testnet
            if (network.isTestnet)
              const Text(
                'Testnet',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit button only for editable networks
            if (network.isEditable)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEditPage(network),
                tooltip: 'Edit',
              ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NetworkDetailPage(
                network: network,
                onNetworkSelected: () {
                  // Handle network selection here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected ${network.name}')),
                  );
                  Navigator.of(context).pop(); // Return to networks list
                },
              ),
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildNetworkIcon(NetworkEntity network) {
    // If the network has a logo URL, you could load it here
    // For now we'll use a placeholder with the first letter
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: network.isTestnet
            ? Colors.orange.withOpacity(0.2)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          network.shortName.isNotEmpty
              ? network.shortName.substring(0, 1).toUpperCase()
              : 'N',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: network.isTestnet ? Colors.orange : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<EvmChainBloc>().add(LoadEvmChainsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
