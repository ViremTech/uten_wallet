import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:uten_wallet/core/network/data/model/network_model.dart';

import '../../../../error/exception.dart';

abstract class EvmChainRemoteDataSource {
  Future<List<NetworkModel>> getEvmChains();
}

class EvmChainRemoteDataSourceImpl implements EvmChainRemoteDataSource {
  final http.Client client;
  final String apiUrl;

  EvmChainRemoteDataSourceImpl({
    http.Client? client,
    this.apiUrl = 'https://chainid.network/chains.json',
  }) : client = client ?? http.Client();

  @override
  Future<List<NetworkModel>> getEvmChains() async {
    try {
      final response = await client.get(Uri.parse(apiUrl)).timeout(
            const Duration(
              seconds: 5,
            ),
          );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) {
          final rpcUrls = (json['rpc'] as List?)?.cast<String>() ?? [];
          final filteredRpcUrls = rpcUrls
              .where((url) => !url.contains('\${') && url.isNotEmpty)
              .toList();

          return NetworkModel(
            id: json['shortName'] ?? '',
            name: json['name'] ?? '',
            shortName: json['shortName'] ?? '',
            chainId: json['chainId'] ?? 0,
            rpc: filteredRpcUrls,
            currencySymbol: json['nativeCurrency']?['symbol'] ?? '',
            currencyName: json['nativeCurrency']?['name'] ?? '',
            decimals: json['nativeCurrency']?['decimals'] ?? 18,
            logoUrl: _getLogoUrl(json['chainId']),
            blockExplorerUrl: json['explorers']?[0]?['url'] ?? '',
            isTestnet: _isTestnet(json['name']),
            isEditable: false,
          );
        }).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  String _getLogoUrl(int chainId) {
    return 'https://icons.llamao.fi/icons/chains/rsz_$chainId.jpg';
  }

  bool _isTestnet(String name) {
    final lowercaseName = name.toLowerCase();
    return lowercaseName.contains('testnet') ||
        lowercaseName.contains('test') ||
        lowercaseName.contains('goerli') ||
        lowercaseName.contains('sepolia') ||
        lowercaseName.contains('ropsten') ||
        lowercaseName.contains('rinkeby') ||
        lowercaseName.contains('kovan') ||
        lowercaseName.contains('mumbai');
  }
}
