import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entity/wallet_entity.dart';
import '../repository/wallet_repo.dart';

class GetAllWallets extends Usecase<List<WalletEntity>, NoParams> {
  final WalletRepo repository;

  GetAllWallets(this.repository);

  @override
  Future<Either<Failure, List<WalletEntity>>> call(NoParams params) {
    return repository.getAllWallets();
  }
}
