import 'package:dartz/dartz.dart';

import '../../../error/failure.dart';
import '../../../usecase/usecase.dart';

import '../entity/network_entity.dart';
import '../repository/network_repo.dart';

class GetNetworkByIdUseCase implements Usecase<NetworkEntity, String> {
  final EvmChainRepository repository;

  GetNetworkByIdUseCase(this.repository);

  @override
  Future<Either<Failure, NetworkEntity>> call(String params) {
    return repository.getNetworkById(params);
  }
}
