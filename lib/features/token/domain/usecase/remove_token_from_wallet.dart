import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';

import '../repository/token_repo.dart';

class RemoveTokenFromWallet implements Usecase<void, RemoveTokenParams> {
  final TokenRepository repository;

  RemoveTokenFromWallet(this.repository);

  Future<Either<Failure, void>> call(
    RemoveTokenParams params,
  ) async {
    return await repository.removeTokenFromWallet(
      params.walletId,
      params.tokenContractAddress,
    );
  }
}

class RemoveTokenParams {
  final String walletId;
  final String tokenContractAddress;

  RemoveTokenParams({
    required this.walletId,
    required this.tokenContractAddress,
  });
}
