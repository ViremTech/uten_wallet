import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/wallet/domain/repository/wallet_repo.dart';

class GenerateMnemonic extends Usecase<String, NoParams> {
  final WalletRepo repository;

  GenerateMnemonic(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.generateMnemonic();
  }
}
