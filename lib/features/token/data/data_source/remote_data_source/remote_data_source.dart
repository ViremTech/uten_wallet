import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';
import '../../../../../core/error/exception.dart';
import '../../model/token_model.dart';

abstract class TokenRemoteDataSource {
  Future<List<TokenModel>> getTokens(int chainId);
  Future<TokenModel> getTokenDetails(String contractAddress, int chainId);
  Future<TokenPrice> getTokenPrice(TokenEntity token);
  Future<Map<String, TokenPrice>> getTokenPrices(List<String> coinGeckoIds);
}

class TokenRemoteDataSourceImpl implements TokenRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://api.coingecko.com/api/v3';
  static const int _maxPriceIdsPerRequest = 50; // CoinGecko's limit

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
        final mydata = (data['data'] as List)
            .map(
              (tokenJson) => TokenModel.fromJson(tokenJson),
            )
            .toList();

        print(mydata.last.code);
        return mydata;
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

  @override
  Future<TokenPrice> getTokenPrice(TokenEntity token) async {
    try {
      if (token.name.isEmpty) {
        return TokenPrice.zero();
      }

      final priceData = await _fetchPriceWithRetry(token.name);

      if (priceData == null) {
        return TokenPrice.zero();
      }

      final usdPrice = (priceData['usd'] ?? 0).toDouble();
      final change24h = (priceData['usd_24h_change'] ?? 0).toDouble();
      final balanceInTokens =
          token.balance.toDouble() / pow(10, token.decimals);
      final totalValue = usdPrice * balanceInTokens;

      print(TokenPrice(
        usdPrice: usdPrice,
        precentageChange: change24h,
        totalUserValueUsd: totalValue,
        lastUpdated: DateTime.now(),
      ));
      return TokenPrice(
        usdPrice: usdPrice,
        precentageChange: change24h,
        totalUserValueUsd: totalValue,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error getting price for ${token.symbol}: $e');
      return TokenPrice.zero();
    }
  }

  @override
  Future<Map<String, TokenPrice>> getTokenPrices(List<String> tokenName) async {
    if (tokenName.isEmpty) return {};

    try {
      // Split into chunks to handle CoinGecko's limit
      final chunks = _chunkList(tokenName, _maxPriceIdsPerRequest);
      final Map<String, TokenPrice> results = {};

      for (final chunk in chunks) {
        final chunkResults = await _fetchPricesForChunk(chunk);
        results.addAll(chunkResults);
      }

      print(results);
      return results;
    } catch (e) {
      print('Error getting batch token prices: $e');
      return {};
    }
  }

  Future<Map<String, TokenPrice>> _fetchPricesForChunk(List<String> ids) async {
    final idString = ids.join(',');
    final response = await client.get(
      Uri.parse(
          '$baseUrl/simple/price?ids=$idString&vs_currencies=usd&include_24hr_change=true'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, TokenPrice> prices = {};

      for (final id in ids) {
        final priceData = data[id];
        if (priceData != null) {
          prices[id] = TokenPrice(
            usdPrice: (priceData['usd'] ?? 0).toDouble(),
            precentageChange: (priceData['usd_24h_change'] ?? 0).toDouble(),
            totalUserValueUsd: 0, // Will be calculated later with balance
            lastUpdated: DateTime.now(),
          );
        }
      }

      return prices;
    } else {
      print('Batch price API error: ${response.statusCode} - ${response.body}');
      throw ServerException();
    }
  }

  List<List<String>> _chunkList(List<String> list, int chunkSize) {
    List<List<String>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  Future<Map<String, dynamic>?> _fetchPriceWithRetry(String coinId,
      {int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await client.get(
          Uri.parse(
              '$baseUrl/simple/price?ids=$coinId&vs_currencies=usd&include_24hr_change=true'),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Just fetched token data : $data');
          return data[coinId] as Map<String, dynamic>?;
        } else if (response.statusCode == 429) {
          print('Rate limited, waiting before retry $attempt/$maxRetries...');
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        } else {
          print(
              'Price API error (attempt $attempt): ${response.statusCode} - ${response.body}');
          if (attempt == maxRetries) throw ServerException();
        }
      } catch (e) {
        print('Price fetch attempt $attempt failed: $e');
        if (attempt == maxRetries) rethrow;
        await Future.delayed(Duration(seconds: attempt));
      }
    }
    return null;
  }

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

  String _getTokenListUrl(int chainId) {
    switch (chainId) {
      case 1:
        return 'https://open-api.openocean.finance/v3/eth/tokenList';
      case 56:
        return 'https://open-api.openocean.finance/v3/bsc/tokenList';
      case 137:
        return 'https://open-api.openocean.finance/v3/polygon/tokenList';
      case 42161:
        return 'https://open-api.openocean.finance/v3/arbitrum/tokenList';
      case 10:
        return 'https://open-api.openocean.finance/v3/optimism/tokenList';
      case 43114:
        return 'https://open-api.openocean.finance/v3/avax/tokenList';
      case 250:
        return 'https://open-api.openocean.finance/v3/fantom/tokenList';
      case 25:
        return 'https://open-api.openocean.finance/v3/cronos/tokenList';
      case 8217:
        return 'https://open-api.openocean.finance/v3/klaytn/tokenList';
      case 42220:
        return 'https://open-api.openocean.finance/v3/celo/tokenList';
      default:
        throw UnsupportedChainException();
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
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class UnsupportedChainException implements Exception {
  final String message = 'Unsupported chain ID';
}
