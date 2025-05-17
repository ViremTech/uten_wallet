// features/token/domain/repositories/token_repository.dart
import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';

import '../../data/model/token_model.dart';
import '../entity/token_entity.dart';

abstract class TokenRepository {
  Future<Either<Failure, List<TokenEntity>>> getTokens(int chainId);
  Future<Either<Failure, List<TokenEntity>>> getCachedTokens(int chainId);
  Future<Either<Failure, void>> cacheTokens(
      int chainId, List<TokenEntity> tokens);
  Future<Either<Failure, TokenEntity>> getTokenDetails(
      String contractAddress, int chainId);
  Future<Either<Failure, void>> addTokenToWallet(
      String walletId, TokenModel token);
  Future<Either<Failure, void>> removeTokenFromWallet(
      String walletId, String tokenContractAddress);
  Future<Either<Failure, List<TokenEntity>>> getWalletTokens(
    String walletId, {
    int? chainId,
  });
}
