// features/token/data/repositories/token_repository_impl.dart
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
      return Left(CacheFailure('Failed to cache tokens'));
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
      return Left(CacheFailure('Failed to cache tokens'));
    }
  }

  @override
  Future<Either<Failure, List<TokenEntity>>> getWalletTokens(
    String walletId, {
    int? chainId,
  }) async {
    try {
      final tokens = await localDataSource.getWalletTokens(walletId);
      final filteredTokens = chainId != null
          ? tokens.where((token) => token.chainId == chainId).toList()
          : tokens;
      return Right(filteredTokens);
    } on CacheException {
      return Left(CacheFailure('Failed to cache tokens'));
    }
  }

  // @override
  // Future<Either<Failure, TokenModel>> getTokenPrice(TokenEntity token) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final remoteToken = await remoteDataSource.getTokenPrice(token);
  //       await localDataSource.cacheTokenPrice(remoteToken);
  //       return Right(remoteToken);
  //     } on ServerException {
  //       return Left(ServerFailure('Server failure'));
  //     } on NotFoundException {
  //       return Left(ServerFailure('Token not found'));
  //     }
  //   } else {
  //     try {
  //       final localToken = await localDataSource.getCachedTokenPrice(token.id);
  //       if (localToken != null) {
  //         return Right(localToken);
  //       } else {
  //         return Left(CacheFailure('No cached data available'));
  //       }
  //     } on CacheException {
  //       return Left(CacheFailure('Cache failure'));
  //     }
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> cacheTokenPrice(TokenEntity token) async {
  //   try {
  //     await localDataSource.cacheTokenPrice(token);
  //     return const Right(null);
  //   } on CacheException {
  //     return Left(CacheFailure('Cache failure'));
  //   }
  // }

  // @override
  // Future<Either<Failure, TokenEntity>> getCachedTokenPrice(
  //     String tokenId) async {
  //   try {
  //     final localToken = await localDataSource.getCachedTokenPrice(tokenId);
  //     if (localToken != null) {
  //       return Right(localToken);
  //     } else {
  //       return Left(CacheFailure('No cached data available'));
  //     }
  //   } on CacheException {
  //     return Left(CacheFailure('Cache failure'));
  //   }
  // }
}
