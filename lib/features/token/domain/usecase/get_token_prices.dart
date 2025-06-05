import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

import 'package:uten_wallet/features/token/domain/repository/token_repo.dart';

class GetTokenPrice implements Usecase<TokenPrice, GetTokenPriceParams> {
  final TokenRepository repository;

  GetTokenPrice(this.repository);

  @override
  Future<Either<Failure, TokenPrice>> call(GetTokenPriceParams params) async {
    return await repository.getTokenPrice(params.token);
  }
}

class GetTokenPriceParams {
  final TokenEntity token;

  GetTokenPriceParams({
    required this.token,
  });
}
