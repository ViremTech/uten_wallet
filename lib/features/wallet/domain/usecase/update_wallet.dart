import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/wallet_entity.dart';
import '../repository/wallet_repo.dart';

class UpdateWalletParams {
  final WalletEntity wallet;

  UpdateWalletParams(this.wallet);
}

class UpdateWallet extends Usecase<void, UpdateWalletParams> {
  final WalletRepo repository;

  UpdateWallet(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateWalletParams params) {
    return repository.updateWallet(params.wallet);
  }
}
