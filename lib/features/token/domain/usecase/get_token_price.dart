import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

import 'package:uten_wallet/features/token/domain/repository/token_repo.dart';

class GetTokenPrices
    implements Usecase<Map<String, TokenPrice>, GetTokenPricesParams> {
  final TokenRepository repository;

  GetTokenPrices(this.repository);

  @override
  Future<Either<Failure, Map<String, TokenPrice>>> call(
      GetTokenPricesParams params) async {
    return await repository.getTokenPrices(params.coinGeckoIds);
  }
}

class GetTokenPricesParams {
  final List<String> coinGeckoIds;

  GetTokenPricesParams({
    required this.coinGeckoIds,
  });
}
