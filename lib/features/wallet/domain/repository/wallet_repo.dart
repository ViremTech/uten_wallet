import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';

abstract class WalletRepo {
  Future<Either<Failure, String>> generateMnemonic();
  Future<Either<Failure, WalletEntity>> generateWallet(
      {required String mnemonic,
      required String name,
      required String network});
  Future<Either<Failure, double>> getTotalBalance();
  Future<Either<Failure, List<WalletEntity>>> getAllWallets();
  Future<Either<Failure, void>> setActiveWallet(String walletId);
  Future<Either<Failure, WalletEntity>> importWallet({
    required String privateKey,
    required String name,
    required String network,
  });
  Future<Either<Failure, void>> deleteWallet(String walletId);
  Future<Either<Failure, void>> updateWallet(WalletEntity wallet);
  Future<Either<Failure, WalletEntity?>> getActiveWallet();
}
