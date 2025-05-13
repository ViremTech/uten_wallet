import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/domain/repository/wallet_repo.dart';

class GenerateWalletParams {
  final String mnemonic;
  final String network;

  GenerateWalletParams({
    required this.mnemonic,
    required this.network,
  });
}

class GenerateWallet extends Usecase<WalletEntity, GenerateWalletParams> {
  final WalletRepo repository;

  GenerateWallet(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(GenerateWalletParams params) {
    return repository.generateWallet(
      mnemonic: params.mnemonic,
      network: params.network,
    );
  }
}
