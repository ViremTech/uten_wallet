import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/wallet_repo.dart';

class GetTotalBalance extends Usecase<double, NoParams> {
  final WalletRepo repository;

  GetTotalBalance(this.repository);

  @override
  Future<Either<Failure, double>> call(NoParams params) {
    return repository.getTotalBalance();
  }
}
