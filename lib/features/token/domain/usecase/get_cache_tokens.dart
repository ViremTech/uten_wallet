import 'package:dartz/dartz.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';

import '../entity/token_entity.dart';
import '../repository/token_repo.dart';

class GetCachedTokens implements Usecase<List<TokenEntity>, int> {
  final TokenRepository repository;

  GetCachedTokens(this.repository);

  @override
  Future<Either<Failure, List<TokenEntity>>> call(int chainId) async {
    return await repository.getCachedTokens(chainId);
  }
}
