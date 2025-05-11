import 'package:dartz/dartz.dart';

import '../../../error/failure.dart';
import '../../../usecase/usecase.dart';
import '../entity/network_entity.dart';
import '../repository/network_repo.dart';

class AddNetwork implements Usecase<bool, NetworkEntity> {
  final EvmChainRepository repository;

  AddNetwork(this.repository);

  @override
  Future<Either<Failure, bool>> call(NetworkEntity params) {
    return repository.addNetwork(params);
  }
}
