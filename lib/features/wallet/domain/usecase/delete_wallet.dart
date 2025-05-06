import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/wallet_repo.dart';

class DeleteWalletParams {
  final String walletId;

  DeleteWalletParams(this.walletId);
}

class DeleteWallet extends Usecase<void, DeleteWalletParams> {
  final WalletRepo repository;

  DeleteWallet(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteWalletParams params) {
    return repository.deleteWallet(params.walletId);
  }
}
