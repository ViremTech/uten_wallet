import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/wallet_entity.dart';
import '../repository/wallet_repo.dart';

class GetActiveWallet extends Usecase<WalletEntity?, NoParams> {
  final WalletRepo repository;

  GetActiveWallet(this.repository);

  @override
  Future<Either<Failure, WalletEntity?>> call(NoParams params) {
    return repository.getActiveWallet();
  }
}
