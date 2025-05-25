// features/token/data/data_source/remote_data_source/token_remote_data_source.dart
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

import '../../../../../core/error/exception.dart';
import '../../model/token_model.dart';

abstract class TokenRemoteDataSource {
  Future<List<TokenModel>> getTokens(int chainId);
  Future<TokenModel> getTokenDetails(String contractAddress, int chainId);
  // Future<TokenPrice> getTokenPrice(TokenEntity token);
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.coingecko.com/api/v3';

  TokenRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TokenModel>> getTokens(int chainId) async {
    try {
      final url = _getTokenListUrl(chainId);
      final response = await client.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<TokenModel> tokens = (data['data'] as List)
            .map((tokenJson) => TokenModel.fromJson(tokenJson))
            .toList();

        // // Add native token for the chain
        // final nativeToken = _getNativeTokenForChain(chainId);
        // tokens.insert(0, nativeToken);

        List<TokenModel> enrichedTokens =
            await Future.wait(tokens.map((token) async {
          try {
            final price = await _fetchTokenPrice(token.name, token);

            return token.copyWith(
              tokenPrice: TokenPrice(
                usdPrice: price!.usdPrice,
                precentageChange: price.precentageChange,
                totalUserValueUsd: price.totalUserValueUsd,
              ),
            );
          } catch (e) {
            print('Error fetching price for ${token.symbol}: $e');
            return token;
          }
        }));

        return enrichedTokens;
      } else {
        print(
            'Token list API error: ${response.statusCode} - ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Error in getTokens: $e');
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

  // TokenModel _getNativeTokenForChain(int chainId) {
  //   // Map of native tokens for different chains with CoinGecko IDs
  //   final nativeTokens = {
  //     1: {
  //       'name': 'Ethereum',
  //       'symbol': 'ETH',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
  //       'coinGeckoId': 'ethereum',
  //     },
  //     56: {
  //       'name': 'Binance Coin',
  //       'symbol': 'BNB',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/bnb.svg',
  //       'coinGeckoId': 'binancecoin',
  //     },
  //     137: {
  //       'name': 'Polygon',
  //       'symbol': 'MATIC',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/matic.svg',
  //       'coinGeckoId': 'matic-network',
  //     },
  //     42161: {
  //       'name': 'Ethereum',
  //       'symbol': 'ETH',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
  //       'coinGeckoId': 'ethereum',
  //     },
  //     10: {
  //       'name': 'Ethereum',
  //       'symbol': 'ETH',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/eth.svg',
  //       'coinGeckoId': 'ethereum',
  //     },
  //     43114: {
  //       'name': 'Avalanche',
  //       'symbol': 'AVAX',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/avax.svg',
  //       'coinGeckoId': 'avalanche-2',
  //     },
  //     250: {
  //       'name': 'Fantom',
  //       'symbol': 'FTM',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/ftm.svg',
  //       'coinGeckoId': 'fantom',
  //     },
  //     25: {
  //       'name': 'Cronos',
  //       'symbol': 'CRO',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/cro.svg',
  //       'coinGeckoId': 'crypto-com-chain',
  //     },
  //     8217: {
  //       'name': 'Klaytn',
  //       'symbol': 'KLAY',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/klay.svg',
  //       'coinGeckoId': 'klay-token',
  //     },
  //     42220: {
  //       'name': 'Celo',
  //       'symbol': 'CELO',
  //       'decimals': 18,
  //       'logoURI':
  //           'https://cdn.jsdelivr.net/gh/atomiclabs/cryptocurrency-icons@d5c68edec1f5eaec59ac77ff2b48144679cebca1/svg/color/celo.svg',
  //       'coinGeckoId': 'celo',
  //     },
  //   };

  //   final nativeTokenData = nativeTokens[chainId] ??
  //       {
  //         'name': 'Native Token',
  //         'symbol': 'NATIVE',
  //         'decimals': 18,
  //         'logoURI': '',
  //         'coinGeckoId': '',
  //       };

  //   return TokenModel(
  //     id: 'native_$chainId',
  //     name: nativeTokenData['name']! as String,
  //     symbol: nativeTokenData['symbol']! as String,
  //     contractAddress: '0x0000000000000000000000000000000000000000',
  //     chainId: chainId,
  //     decimals: nativeTokenData['decimals']! as int,
  //     logoURI: nativeTokenData['logoURI']! as String,
  //     isNative: true,
  //     balance: BigInt.zero,
  //     coinGeckoId: nativeTokenData['coinGeckoId']! as String,
  //     tokenPrice: TokenPrice(
  //       usdPrice: 0,
  //       precentageChange: 0,
  //       totalUserValueUsd: 0,
  //     ),
  //   );
  // }

  @override
  Future<TokenModel> getTokenDetails(
      String contractAddress, int chainId) async {
    try {
      final platformId = _getPlatformId(chainId);
      final response = await client.get(
        Uri.parse('$baseUrl/coins/$platformId/contract/$contractAddress'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(json.decode(response.body));
      } else {
        print(
            'Token details API error: ${response.statusCode} - ${response.body}');
        throw ServerException();
      }
    } catch (e) {
      print('Error in getTokenDetails: $e');
      throw ServerException();
    }
  }

  String _getPlatformId(int chainId) {
    switch (chainId) {
      case 1:
        return 'ethereum';
      case 56:
        return 'binance-smart-chain';
      case 137:
        return 'polygon-pos';
      case 42161:
        return 'arbitrum-one';
      case 10:
        return 'optimistic-ethereum';
      case 43114:
        return 'avalanche';
      case 250:
        return 'fantom';
      case 25:
        return 'cronos';
      default:
        return 'ethereum';
    }
  }

  // @override
  // Future<TokenPrice> getTokenPrice(TokenEntity token) async {
  //   try {
  //     String? coinId;

  //     // First try to use coinGeckoId if available (for native tokens)
  //     if (token.coinGeckoId != null && token.coinGeckoId!.isNotEmpty) {
  //       coinId = token.coinGeckoId;
  //     } else {
  //       // Search for the token using multiple strategies
  //       coinId = await _findCoinId(token);
  //     }

  //     if (coinId == null) {
  //       print(
  //           'Could not find CoinGecko ID for token: ${token.symbol} (${token.name})');
  //       // Return zero price instead of throwing error
  //       return TokenPrice(
  //         usdPrice: 0,
  //         precentageChange: 0,
  //         totalUserValueUsd: 0,
  //         lastUpdated: DateTime.now(),
  //       );
  //     }

  //     // Get price data with retry mechanism
  //     final priceData = await _fetchPriceWithRetry(coinId);

  //     if (priceData == null) {
  //       print('No price data available for ${token.symbol}');
  //       return TokenPrice(
  //         usdPrice: 0,
  //         precentageChange: 0,
  //         totalUserValueUsd: 0,
  //         lastUpdated: DateTime.now(),
  //       );
  //     }

  //     final usdPrice = (priceData['usd'] ?? 0).toDouble();
  //     final change24h = (priceData['usd_24h_change'] ?? 0).toDouble();

  //     // Calculate total user value
  //     final balanceInTokens =
  //         token.balance.toDouble() / pow(10, token.decimals);
  //     final totalValue = usdPrice * balanceInTokens;

  //     print(
  //         'Price fetched for ${token.symbol}: \${usdPrice.toStringAsFixed(6)}, Total Value: \${totalValue.toStringAsFixed(2)}');

  //     return TokenPrice(
  //       usdPrice: usdPrice,
  //       precentageChange: change24h,
  //       totalUserValueUsd: totalValue,
  //       lastUpdated: DateTime.now(),
  //     );
  //   } on ServerException {
  //     rethrow;
  //   } catch (e) {
  //     print('Unexpected error in getTokenPrice for ${token.symbol}: $e');
  //     return TokenPrice(
  //       usdPrice: 0,
  //       precentageChange: 0,
  //       totalUserValueUsd: 0,
  //       lastUpdated: DateTime.now(),
  //     );
  //   }
  // }

  Future<TokenPrice?> _fetchTokenPrice(
      String coinName, TokenModel token) async {
    final url = Uri.parse(
      '$baseUrl/simple/price?ids=${coinName.toLowerCase()}&vs_currencies=usd&include_24hr_change=true',
    );

    try {
      final response = await client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final coinData = data[coinName.toLowerCase()];
        if (coinData == null ||
            coinData['usd'] == null ||
            coinData['usd_24h_change'] == null) {
          print('Incomplete data for $coinName: $coinData');
          return null;
        }

        final double price = (coinData['usd'] as num).toDouble();
        final double percentChange =
            (coinData['usd_24h_change'] as num).toDouble();
        final double balanceInTokens =
            token.balance.toDouble() / pow(10, token.decimals);
        final double totalValue = price * balanceInTokens;

        return TokenPrice(
          usdPrice: price,
          precentageChange: percentChange,
          totalUserValueUsd: totalValue,
        );
      } else {
        print(
            'Failed to fetch token price: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Exception in _fetchTokenPrice for $coinName: $e');
      print(stackTrace);
      return null;
    }
  }

  // // Helper method to fetch price with retry mechanism
  // Future<Map<String, dynamic>?> _fetchPriceWithRetry(String coinId,
  //     {int maxRetries = 3}) async {
  //   for (int attempt = 1; attempt <= maxRetries; attempt++) {
  //     try {
  //       final priceResponse = await client.get(
  //         Uri.parse(
  //             '$baseUrl/simple/price?ids=$coinId&vs_currencies=usd&include_24hr_change=true'),
  //         headers: {'Content-Type': 'application/json'},
  //       );

  //       if (priceResponse.statusCode == 200) {
  //         final priceData = json.decode(priceResponse.body);

  //         if (priceData.containsKey(coinId)) {
  //           return priceData[coinId] as Map<String, dynamic>;
  //         } else {
  //           print('No price data found for coinId: $coinId in response');
  //           return null;
  //         }
  //       } else if (priceResponse.statusCode == 429) {
  //         // Rate limited, wait longer before retry
  //         print('Rate limited, waiting before retry $attempt/$maxRetries...');
  //         await Future.delayed(Duration(seconds: attempt * 2));
  //         continue;
  //       } else {
  //         print(
  //             'Price API error (attempt $attempt): ${priceResponse.statusCode} - ${priceResponse.body}');
  //         if (attempt == maxRetries) {
  //           throw ServerException();
  //         }
  //       }
  //     } catch (e) {
  //       print('Price fetch attempt $attempt failed: $e');
  //       if (attempt == maxRetries) {
  //         rethrow;
  //       }
  //       await Future.delayed(Duration(seconds: attempt));
  //     }
  //   }
  //   return null;
  // }

  // Future<String?> _findCoinId(TokenEntity token) async {
  //   try {
  //     // Strategy 1: Check hardcoded mappings for known problematic tokens
  //     final hardcodedId = _getHardcodedCoinId(token.symbol, token.name);
  //     if (hardcodedId != null) {
  //       return hardcodedId;
  //     }

  //     // Strategy 2: Contract-based lookup (most reliable for ERC-20 tokens)
  //     if (token.contractAddress.isNotEmpty &&
  //         token.contractAddress !=
  //             '0x0000000000000000000000000000000000000000') {
  //       try {
  //         final platformId = _getPlatformId(token.chainId);
  //         final contractResponse = await client.get(
  //           Uri.parse(
  //               '$baseUrl/coins/$platformId/contract/${token.contractAddress}'),
  //           headers: {'Content-Type': 'application/json'},
  //         );

  //         if (contractResponse.statusCode == 200) {
  //           final contractData = json.decode(contractResponse.body);
  //           final coinId = contractData['id'] as String?;
  //           if (coinId != null) {
  //             print(
  //                 'Found CoinGecko ID via contract for ${token.symbol}: $coinId');
  //             return coinId;
  //           }
  //         }
  //       } catch (e) {
  //         print('Contract-based lookup failed for ${token.symbol}: $e');
  //       }
  //     }

  //     // Strategy 3: Search by symbol with multiple attempts
  //     final searchStrategies = [
  //       token.symbol,
  //       token.name,
  //       '${token.symbol} ${token.name}',
  //       token.symbol.replaceAll('.', ''), // Remove dots like in SolvBTC.BBN
  //     ];

  //     for (final query in searchStrategies) {
  //       try {
  //         final searchResponse = await client.get(
  //           Uri.parse('$baseUrl/search?query=${Uri.encodeComponent(query)}'),
  //           headers: {'Content-Type': 'application/json'},
  //         );

  //         if (searchResponse.statusCode == 200) {
  //           final searchData = json.decode(searchResponse.body);
  //           final coins = searchData['coins'] as List?;

  //           if (coins != null && coins.isNotEmpty) {
  //             // Try exact symbol match first
  //             var coin = coins.firstWhere(
  //               (c) =>
  //                   (c['symbol'] as String?)?.toLowerCase() ==
  //                   token.symbol.toLowerCase(),
  //               orElse: () => null,
  //             );

  //             // Try partial name match
  //             if (coin == null) {
  //               coin = coins.firstWhere(
  //                 (c) =>
  //                     (c['name'] as String?)
  //                         ?.toLowerCase()
  //                         .contains(token.name.toLowerCase()) ==
  //                     true,
  //                 orElse: () => null,
  //               );
  //             }

  //             // Try partial symbol match
  //             if (coin == null && query == token.symbol) {
  //               coin = coins.firstWhere(
  //                 (c) =>
  //                     (c['symbol'] as String?)
  //                         ?.toLowerCase()
  //                         .contains(token.symbol.toLowerCase()) ==
  //                     true,
  //                 orElse: () => null,
  //               );
  //             }

  //             if (coin != null) {
  //               final coinId = coin['id'] as String?;
  //               print(
  //                   'Found CoinGecko ID via search for ${token.symbol}: $coinId');
  //               return coinId;
  //             }
  //           }
  //         }

  //         // Add small delay between search attempts to avoid rate limiting
  //         await Future.delayed(const Duration(milliseconds: 100));
  //       } catch (e) {
  //         print('Search failed for ${token.symbol} with query "$query": $e');
  //       }
  //     }

  //     return null;
  //   } catch (e) {
  //     print('Error in _findCoinId for ${token.symbol}: $e');
  //     return null;
  //   }
  // }

  // // Hardcoded mappings for tokens that are difficult to find via search
  // String? _getHardcodedCoinId(String symbol, String name) {
  //   final hardcodedMappings = {
  //     // Add known problematic tokens here
  //     'UST': 'terrausd', // TerraUSD
  //     'RSS3': 'rss3',
  //     'LUNA': 'terra-luna-2',
  //     'LUNC': 'terra-luna',
  //     'USTC': 'terraclassicusd',
  //     // Add more as you discover them
  //   };

  //   return hardcodedMappings[symbol.toUpperCase()];
  // }
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class UnsupportedChainException implements Exception {
  final String message = 'Unsupported chain ID';
}
