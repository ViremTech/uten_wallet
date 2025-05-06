import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/wallet_entity.dart';
import '../repository/wallet_repo.dart';

class ImportWalletParams {
  final String privateKey;
  final String name;
  final String network;

  ImportWalletParams({
    required this.privateKey,
    required this.name,
    required this.network,
  });
}

class ImportWallet extends Usecase<WalletEntity, ImportWalletParams> {
  final WalletRepo repository;

  ImportWallet(this.repository);

  @override
  Future<Either<Failure, WalletEntity>> call(ImportWalletParams params) {
    return repository.importWallet(
      privateKey: params.privateKey,
      name: params.name,
      network: params.network,
    );
  }
}
