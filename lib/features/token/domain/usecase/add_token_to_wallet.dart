// features/token/domain/usecases/add_token_to_wallet.dart
import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';

import '../repository/token_repo.dart';

class AddTokenToWallet implements Usecase<void, AddTokenParams> {
  final TokenRepository repository;

  AddTokenToWallet(this.repository);

  @override
  Future<Either<Failure, void>> call(AddTokenParams params) async {
    return await repository.addTokenToWallet(params.walletId, params.token);
  }
}

class AddTokenParams {
  final String walletId;
  final TokenModel token;

  AddTokenParams({required this.walletId, required this.token});
}
