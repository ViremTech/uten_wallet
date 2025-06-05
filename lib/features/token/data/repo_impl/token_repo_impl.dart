import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/network_info/network_info.dart';
import '../../domain/entity/token_entity.dart';

import '../../domain/repository/token_repo.dart';
import '../data_source/local_data_source/local_data_source.dart';
import '../data_source/remote_data_source/remote_data_source.dart';
import '../model/token_model.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenRemoteDataSource remoteDataSource;
  final TokenLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TokenRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TokenEntity>>> getTokens(int chainId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTokens = await remoteDataSource.getTokens(chainId);
        await localDataSource.cacheTokens(chainId, remoteTokens);
        return Right(remoteTokens);
      } on ServerException {
        return Left(ServerFailure('Failed to fetch tokens'));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TokenEntity>>> getCachedTokens(
      int chainId) async {
    try {
      final localTokens = await localDataSource.getCachedTokens(chainId);
      return Right(localTokens);
    } on CacheException {
      return Left(CacheFailure('Failed to load cached tokens'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTokens(
      int chainId, List<TokenEntity> tokens) async {
    try {
      final tokenModels =
          tokens.map((token) => TokenModel.fromEntity(token)).toList();
      await localDataSource.cacheTokens(chainId, tokenModels);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to cache tokens'));
    }
  }

  @override
  Future<Either<Failure, TokenEntity>> getTokenDetails(
      String contractAddress, int chainId) async {
    if (await networkInfo.isConnected) {
      try {
        final token =
            await remoteDataSource.getTokenDetails(contractAddress, chainId);
        return Right(token);
      } on ServerException {
        return Left(ServerFailure('Failed to fetch token details'));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addTokenToWallet(
      String walletId, TokenModel token) async {
    try {
      await localDataSource.addTokenToWallet(walletId, token);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to add token to wallet'));
    }
  }

  @override
  Future<Either<Failure, void>> removeTokenFromWallet(
      String walletId, String tokenContractAddress) async {
    try {
      await localDataSource.removeTokenFromWallet(
          walletId, tokenContractAddress);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to remove token from wallet'));
    }
  }

  @override
  Future<Either<Failure, List<TokenEntity>>> getWalletTokens(String walletId,
      {int? chainId}) async {
    try {
      final tokens = await localDataSource.getWalletTokens(walletId);
      final filteredTokens = chainId != null
          ? tokens.where((token) => token.chainId == chainId).toList()
          : tokens;
      return Right(filteredTokens);
    } on CacheException {
      return Left(CacheFailure('Failed to get wallet tokens'));
    }
  }

  @override
  Future<Either<Failure, TokenPrice>> getTokenPrice(TokenEntity token) async {
    if (token.name.isEmpty) {
      return Right(TokenPrice.zero());
    }

    if (await networkInfo.isConnected) {
      try {
        final price = await remoteDataSource.getTokenPrice(token);
        return Right(price);
      } on ServerException {
        return Left(ServerFailure('Failed to fetch token price'));
      }
    } else {
      try {
        final cachedPrices = await localDataSource.getCachedTokenPrices();
        final cachedPrice = cachedPrices[token.name];
        return cachedPrice != null
            ? Right(cachedPrice)
            : Right(TokenPrice.zero());
      } on CacheException {
        return Left(CacheFailure('Failed to load cached prices'));
      }
    }
  }

  @override
  Future<Either<Failure, Map<String, TokenPrice>>> getTokenPrices(
      List<String> tokenName) async {
    if (tokenName.isEmpty) {
      return Right({});
    }

    if (await networkInfo.isConnected) {
      try {
        final prices = await remoteDataSource.getTokenPrices(tokenName);
        await localDataSource.cacheTokenPrices(prices);
        return Right(prices);
      } on ServerException {
        return Left(ServerFailure('Failed to fetch token prices'));
      }
    } else {
      try {
        final cachedPrices = await localDataSource.getCachedTokenPrices();
        // Filter only the prices we need
        final filteredPrices = <String, TokenPrice>{};
        for (final id in tokenName) {
          if (cachedPrices.containsKey(id)) {
            filteredPrices[id] = cachedPrices[id]!;
          }
        }
        return Right(filteredPrices);
      } on CacheException {
        return Left(CacheFailure('Failed to load cached prices'));
      }
    }
  }

  @override
  Future<Either<Failure, List<TokenModel>>> updateTokenPrices(
      List<TokenModel> tokens) async {
    try {
      final tokensToUpdate = tokens.where((t) => t.tokenPrice.isStale).toList();
      // print('Tokens is $tokensToUpdate');
      // print('last token code is ${tokensToUpdate.last.code}');

      if (tokensToUpdate.isEmpty) {
        return Right(tokens);
      }

      final coinCodes = tokensToUpdate.map((t) => t.code).toList();
      // print('Coin Codes: $coinCodes');

      final pricesResult = await getTokenPrices(coinCodes);
      return pricesResult.fold(
        (failure) => Left(failure),
        (prices) {
          final updatedTokens = tokens.map((token) {
            if (prices.containsKey(token.code)) {
              final price = prices[token.code]!;
              return TokenModel.fromEntity(token).updatePrice(
                usdPrice: price.usdPrice,
                precentageChange: price.precentageChange,
                totalUserValueUsd: price.usdPrice *
                    (token.balance.toDouble() / pow(10, token.decimals)),
              );
            }
            return TokenModel.fromEntity(token);
          }).toList();

          return Right(updatedTokens);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to update token prices: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTokenPrices(
      Map<String, TokenPrice> prices) async {
    try {
      await localDataSource.cacheTokenPrices(prices);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to cache prices'));
    }
  }
}
