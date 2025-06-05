import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';
import 'package:uten_wallet/features/token/domain/repository/token_repo.dart';

class UpdateTokenPrices
    implements Usecase<List<TokenEntity>, UpdateTokenPricesParams> {
  final TokenRepository repository;

  UpdateTokenPrices(this.repository);

  @override
  Future<Either<Failure, List<TokenModel>>> call(
      UpdateTokenPricesParams params) async {
    return await repository.updateTokenPrices(params.tokens);
  }
}

class UpdateTokenPricesParams {
  final List<TokenModel> tokens;

  UpdateTokenPricesParams({
    required this.tokens,
  });
}
