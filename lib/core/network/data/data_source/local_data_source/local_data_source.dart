// lib/core/network/data/data_source/local_data_source/local_data_source.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:uten_wallet/core/network/data/model/network_model.dart';

import '../../../../error/exception.dart';

abstract class EvmChainLocalDataSource {
  /// Gets the cached list of EVM chains
  /// Throws [CacheException] if no cached data is present.
  Future<List<NetworkModel>> getCachedEvmChains();

  /// Caches the list of EVM chains
  Future<void> cacheEvmChains(List<NetworkModel> networks);

  /// Adds a new network to the cached list
  Future<bool> addNetwork(NetworkModel network);

  /// Updates a network in the cached list
  Future<bool> updateNetwork(NetworkModel network);

  /// Deletes a network from the cached list
  Future<bool> deleteNetwork(String networkId);

  /// Gets a network by its ID
  Future<NetworkModel> getNetworkById(String networkId);

  /// Gets predefined networks that should always be available
  List<NetworkModel> getPredefinedNetworks();
}

class EvmChainLocalDataSourceImpl implements EvmChainLocalDataSource {
  final FlutterSecureStorage storage;
  final String _cacheKey = 'CACHED_EVM_CHAINS';

  EvmChainLocalDataSourceImpl({required this.storage});

  @override
  Future<List<NetworkModel>> getCachedEvmChains() async {
    try {
      final jsonString = await storage.read(key: _cacheKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => NetworkModel.fromJson(json)).toList();
      } else {
        // If no cached data, return predefined networks
        final predefinedNetworks = getPredefinedNetworks();
        await cacheEvmChains(predefinedNetworks);
        return predefinedNetworks;
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheEvmChains(List<NetworkModel> networks) async {
    final predefinedNetworks = getPredefinedNetworks();

    // Create a set of predefined network IDs for quick lookup
    final predefinedIds = predefinedNetworks.map((n) => n.id).toSet();

    // Filter out existing predefined networks from the incoming list
    final filteredNetworks =
        networks.where((n) => !predefinedIds.contains(n.id)).toList();

    // Combine predefined networks with filtered networks
    final combinedNetworks = [...predefinedNetworks, ...filteredNetworks];

    // Save to storage
    try {
      final jsonString =
          json.encode(combinedNetworks.map((n) => n.toJson()).toList());
      await storage.write(key: _cacheKey, value: jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> addNetwork(NetworkModel network) async {
    try {
      final networks = await getCachedEvmChains();

      // Check if network with same ID already exists
      if (networks.any((n) => n.id == network.id)) {
        return false;
      }

      networks.add(network);
      await cacheEvmChains(networks);
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> updateNetwork(NetworkModel network) async {
    try {
      final networks = await getCachedEvmChains();

      // Find the index of the network to update
      final index = networks.indexWhere((n) => n.id == network.id);
      if (index == -1) {
        return false;
      }

      // Only allow updating editable networks
      if (!networks[index].isEditable) {
        return false;
      }

      networks[index] = network;
      await cacheEvmChains(networks);
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> deleteNetwork(String networkId) async {
    try {
      final networks = await getCachedEvmChains();

      // Find the network to delete
      final networkIndex = networks.indexWhere((n) => n.id == networkId);
      if (networkIndex == -1) {
        return false;
      }

      // Only allow deleting editable networks
      if (!networks[networkIndex].isEditable) {
        return false;
      }

      networks.removeAt(networkIndex);
      await cacheEvmChains(networks);
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<NetworkModel> getNetworkById(String networkId) async {
    try {
      final networks = await getCachedEvmChains();
      final network = networks.firstWhere(
        (n) => n.id == networkId,
        orElse: () => throw CacheException(),
      );
      return network;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  List<NetworkModel> getPredefinedNetworks() {
    return [
      // Ethereum Mainnet
      const NetworkModel(
        id: 'ethereum',
        name: 'Ethereum Mainnet',
        shortName: 'ETH',
        chainId: 1,
        rpc: ['https://eth.llamarpc.com', 'https://ethereum.publicnode.com'],
        currencySymbol: 'ETH',
        currencyName: 'Ethereum',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_1.jpg',
        blockExplorerUrl: 'https://etherscan.io',
        isTestnet: false,
        isEditable: false,
      ),

      // Ethereum Testnets
      const NetworkModel(
        id: 'sepolia',
        name: 'Sepolia Testnet',
        shortName: 'ETH',
        chainId: 11155111,
        rpc: [
          'https://ethereum-sepolia.publicnode.com',
          'https://sepolia.infura.io/v3/'
        ],
        currencySymbol: 'ETH',
        currencyName: 'Ethereum',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_11155111.jpg',
        blockExplorerUrl: 'https://sepolia.etherscan.io',
        isTestnet: true,
        isEditable: false,
      ),
      const NetworkModel(
        id: 'goerli',
        name: 'Goerli Testnet',
        shortName: 'ETH',
        chainId: 5,
        rpc: [
          'https://ethereum-goerli.publicnode.com',
          'https://goerli.infura.io/v3/'
        ],
        currencySymbol: 'ETH',
        currencyName: 'Ethereum',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_5.jpg',
        blockExplorerUrl: 'https://goerli.etherscan.io',
        isTestnet: true,
        isEditable: false,
      ),

      // Binance Smart Chain
      const NetworkModel(
        id: 'bsc',
        name: 'Binance Smart Chain',
        shortName: 'BSC',
        chainId: 56,
        rpc: [
          'https://bsc-dataseed.binance.org/',
          'https://bsc-dataseed1.defibit.io/'
        ],
        currencySymbol: 'BNB',
        currencyName: 'BNB',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_56.jpg',
        blockExplorerUrl: 'https://bscscan.com',
        isTestnet: false,
        isEditable: false,
      ),

      // Binance Smart Chain Testnet
      const NetworkModel(
        id: 'bsc-testnet',
        name: 'BSC Testnet',
        shortName: 'BSC',
        chainId: 97,
        rpc: [
          'https://data-seed-prebsc-1-s1.binance.org:8545/',
          'https://data-seed-prebsc-2-s1.binance.org:8545/'
        ],
        currencySymbol: 'BNB',
        currencyName: 'BNB',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_97.jpg',
        blockExplorerUrl: 'https://testnet.bscscan.com',
        isTestnet: true,
        isEditable: false,
      ),

      // Polygon Mainnet
      const NetworkModel(
        id: 'polygon',
        name: 'Polygon Mainnet',
        shortName: 'MATIC',
        chainId: 137,
        rpc: ['https://polygon-rpc.com', 'https://polygon.llamarpc.com'],
        currencySymbol: 'MATIC',
        currencyName: 'Polygon',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_137.jpg',
        blockExplorerUrl: 'https://polygonscan.com',
        isTestnet: false,
        isEditable: false,
      ),

      // Polygon Mumbai Testnet
      const NetworkModel(
        id: 'mumbai',
        name: 'Polygon Mumbai',
        shortName: 'MATIC',
        chainId: 80001,
        rpc: [
          'https://rpc-mumbai.maticvigil.com',
          'https://polygon-mumbai.public.blastapi.io'
        ],
        currencySymbol: 'MATIC',
        currencyName: 'Polygon',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_80001.jpg',
        blockExplorerUrl: 'https://mumbai.polygonscan.com',
        isTestnet: true,
        isEditable: false,
      ),

      // Arbitrum
      const NetworkModel(
        id: 'arbitrum',
        name: 'Arbitrum One',
        shortName: 'ARB',
        chainId: 42161,
        rpc: [
          'https://arb1.arbitrum.io/rpc',
          'https://arbitrum-one.public.blastapi.io'
        ],
        currencySymbol: 'ETH',
        currencyName: 'Ethereum',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_42161.jpg',
        blockExplorerUrl: 'https://arbiscan.io',
        isTestnet: false,
        isEditable: false,
      ),

      // Optimism
      const NetworkModel(
        id: 'optimism',
        name: 'Optimism',
        shortName: 'OP',
        chainId: 10,
        rpc: ['https://mainnet.optimism.io', 'https://optimism.llamarpc.com'],
        currencySymbol: 'ETH',
        currencyName: 'Ethereum',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_10.jpg',
        blockExplorerUrl: 'https://optimistic.etherscan.io',
        isTestnet: false,
        isEditable: false,
      ),

      // Avalanche C-Chain
      const NetworkModel(
        id: 'avalanche',
        name: 'Avalanche C-Chain',
        shortName: 'AVAX',
        chainId: 43114,
        rpc: [
          'https://api.avax.network/ext/bc/C/rpc',
          'https://avalanche-c-chain.publicnode.com'
        ],
        currencySymbol: 'AVAX',
        currencyName: 'Avalanche',
        decimals: 18,
        logoUrl: 'https://icons.llamao.fi/icons/chains/rsz_43114.jpg',
        blockExplorerUrl: 'https://snowtrace.io',
        isTestnet: false,
        isEditable: false,
      ),
    ];
  }
}
