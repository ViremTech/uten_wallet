import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

import '../../../../core/error/failure.dart';

import '../repository/token_repo.dart';

class GetWalletTokens implements Usecase<List<TokenEntity>, Params> {
  final TokenRepository repository;

  GetWalletTokens(this.repository);

  @override
  Future<Either<Failure, List<TokenEntity>>> call(Params params) async {
    return await repository.getWalletTokens(params.walletId,
        chainId: params.chainId);
  }
}

class Params {
  String walletId;
  int? chainId;
  Params(this.walletId, {this.chainId});
}
