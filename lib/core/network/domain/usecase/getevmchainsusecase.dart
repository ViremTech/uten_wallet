// lib/core/network/domain/usecase/getevmchainsusecase.dart

import 'package:dartz/dartz.dart';

import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/domain/repository/network_repo.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';

import '../../../error/failure.dart';

class GetEvmChains implements Usecase<List<NetworkEntity>, NoParams> {
  final EvmChainRepository repository;

  GetEvmChains(this.repository);

  @override
  Future<Either<Failure, List<NetworkEntity>>> call(NoParams params) {
    return repository.getEvmChains();
  }
}
