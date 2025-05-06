import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/wallet_repo.dart';

class SetActiveWalletParams {
  final String walletId;

  SetActiveWalletParams(this.walletId);
}

class SetActiveWallet extends Usecase<void, SetActiveWalletParams> {
  final WalletRepo repository;

  SetActiveWallet(this.repository);

  @override
  Future<Either<Failure, void>> call(SetActiveWalletParams params) {
    return repository.setActiveWallet(params.walletId);
  }
}
