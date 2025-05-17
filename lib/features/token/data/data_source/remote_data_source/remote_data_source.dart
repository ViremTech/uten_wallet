// features/token/data/data_source/remote_data_source/token_remote_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../core/error/exception.dart';
import '../../model/token_model.dart';

abstract class TokenRemoteDataSource {
  Future<List<TokenModel>> getTokens(int chainId);
  Future<TokenModel> getTokenDetails(String contractAddress, int chainId);
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final http.Client client;

  TokenRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TokenModel>> getTokens(int chainId) async {
    try {
      final url = _getTokenListUrl(chainId);
      final response = await client.get(Uri.parse(url));
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<TokenModel> tokens = (data['data'] as List)
            .map((tokenJson) => TokenModel.fromJson(tokenJson))
            .toList();

        // Add native token for the chain
        final nativeToken = _getNativeTokenForChain(chainId);
        tokens.insert(0, nativeToken);

        return tokens;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  String _getTokenListUrl(int chainId) {
    switch (chainId) {
      case 1: // Ethereum Mainnet
        return 'https://open-api.openocean.finance/v3/eth/tokenList';
      case 56: // Binance Smart Chain (BSC) Mainnet
        return 'https://open-api.openocean.finance/v3/bsc/tokenList';
      case 137: // Polygon Mainnet
        return 'https://open-api.openocean.finance/v3/polygon/tokenList';
      case 42161: // Arbitrum Mainnet
        return 'https://open-api.openocean.finance/v3/arbitrum/tokenList';
      case 10: // Optimism Mainnet
        return 'https://open-api.openocean.finance/v3/optimism/tokenList';
      case 43114: // Avalanche C-Chain Mainnet
        return 'https://open-api.openocean.finance/v3/avax/tokenList';
      case 250: // Fantom Mainnet
        return 'https://open-api.openocean.finance/v3/fantom/tokenList';
      case 25: // Cronos Mainnet
        return 'https://open-api.openocean.finance/v3/cronos/tokenList';
      case 8217: // Klaytn Mainnet
        return 'https://open-api.openocean.finance/v3/klaytn/tokenList';
      case 42220: // Celo Mainnet
        return 'https://open-api.openocean.finance/v3/celo/tokenList';
      default:
        throw UnsupportedChainException();
    }
  }

  TokenModel _getNativeTokenForChain(int chainId) {
    // Map of native tokens for different chains
    final nativeTokens = {
      1: {
        'name': 'Ethereum',
        'symbol': 'ETH',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
      },
      56: {
        'name': 'Binance Coin',
        'symbol': 'BNB',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/bnb.svg',
      },
      137: {
        'name': 'Matic',
        'symbol': 'MATIC',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/matic.svg',
      },
      42161: {
        'name': 'Ethereum',
        'symbol': 'ETH',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
      },
      10: {
        'name': 'Ethereum',
        'symbol': 'ETH',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
      },
      43114: {
        'name': 'Avalanche',
        'symbol': 'AVAX',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/avax.svg',
      },
      250: {
        'name': 'Fantom',
        'symbol': 'FTM',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/ftm.svg',
      },
      25: {
        'name': 'Cronos',
        'symbol': 'CRO',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/cro.svg',
      },
      8217: {
        'name': 'Klaytn',
        'symbol': 'KLAY',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/klay.svg',
      },
      42220: {
        'name': 'Celo',
        'symbol': 'CELO',
        'decimals': 18,
        'logoURI':
            'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/celo.svg',
      },
    };

    final nativeTokenData = nativeTokens[chainId] ??
        {
          'name': 'Native Token',
          'symbol': 'NATIVE',
          'decimals': 18,
          'logoURI': '',
        };

    return TokenModel(
      id: 'native_$chainId',
      name: nativeTokenData['name']! as String,
      symbol: nativeTokenData['symbol']! as String,
      contractAddress: '0x0000000000000000000000000000000000000000',
      chainId: chainId,
      decimals: nativeTokenData['decimals']! as int,
      logoURI: nativeTokenData['logoURI']! as String,
      isNative: true,
      balance: BigInt.zero,
    );
  }

  @override
  Future<TokenModel> getTokenDetails(
      String contractAddress, int chainId) async {
    try {
      // This is a placeholder - you would need to implement actual API call
      // to CoinGecko or CoinMarketCap
      final response = await client.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/$chainId/contract/$contractAddress'),
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

class UnsupportedChainException implements Exception {
  final String message = 'Unsupported chain ID';
}
