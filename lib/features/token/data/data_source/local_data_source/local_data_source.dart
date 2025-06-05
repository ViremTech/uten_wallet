// features/token/data/datasources/token_local_data_source.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/error/exception.dart';
import '../../../../wallet/data/data_source/wallet_local_storage.dart';
import '../../../domain/entity/token_entity.dart';

import '../../model/token_model.dart';

abstract class TokenLocalDataSource {
  Future<List<TokenModel>> getCachedTokens(int chainId);
  Future<void> cacheTokens(int chainId, List<TokenModel> tokens);
  Future<void> addTokenToWallet(String walletId, TokenModel token);
  Future<void> removeTokenFromWallet(
      String walletId, String tokenContractAddress);
  Future<List<TokenModel>> getWalletTokens(String walletId, {int? chainId});
  Future<void> cacheTokenPrices(Map<String, TokenPrice> prices);
  Future<Map<String, TokenPrice>> getCachedTokenPrices();
}

class TokenLocalDataSourceImpl implements TokenLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final WalletLocalStorage walletLocalStorage;
  static const String _priceCacheKey = 'token_price_cache';

  TokenLocalDataSourceImpl({
    required this.secureStorage,
    required this.walletLocalStorage,
  });

  @override
  Future<List<TokenModel>> getCachedTokens(int chainId) async {
    try {
      final jsonString =
          await secureStorage.read(key: 'cached_tokens_$chainId') ?? '[]';
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => TokenModel.fromJson(json)).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTokens(int chainId, List<TokenModel> tokens) async {
    try {
      final jsonString =
          json.encode(tokens.map((token) => token.toJson()).toList());
      await secureStorage.write(
        key: 'cached_tokens_$chainId',
        value: jsonString,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addTokenToWallet(String walletId, TokenModel token) async {
    await walletLocalStorage.addTokenToWallet(walletId, token);
  }

  @override
  Future<void> removeTokenFromWallet(
      String walletId, String tokenContractAddress) async {
    await walletLocalStorage.removeTokenFromWallet(
        walletId, tokenContractAddress);
  }

  @override
  Future<List<TokenModel>> getWalletTokens(String walletId,
      {int? chainId}) async {
    return await walletLocalStorage.getWalletTokens(walletId, chainId: chainId);
  }

  @override
  Future<void> cacheTokenPrices(Map<String, TokenPrice> prices) async {
    try {
      final priceMap =
          prices.map((key, value) => MapEntry(key, value.toJson()));
      await secureStorage.write(
        key: _priceCacheKey,
        value: json.encode(priceMap),
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Map<String, TokenPrice>> getCachedTokenPrices() async {
    try {
      final jsonString = await secureStorage.read(key: _priceCacheKey);
      if (jsonString == null) return {};

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap.map((key, value) => MapEntry(
            key,
            TokenPrice.fromJson(value),
          ));
    } catch (e) {
      throw CacheException();
    }
  }
}
