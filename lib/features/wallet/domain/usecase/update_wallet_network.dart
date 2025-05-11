import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';

import '../repository/wallet_repo.dart';

class UpdateWalletNetwork extends Usecase<void, String> {
  final WalletRepo repository;

  UpdateWalletNetwork(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.updateWalletNetwork(params);
  }
}
