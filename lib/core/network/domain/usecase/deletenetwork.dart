import 'package:dartz/dartz.dart';

import '../../../error/failure.dart';
import '../../../usecase/usecase.dart';

import '../repository/network_repo.dart';

class DeleteNetwork implements Usecase<bool, String> {
  final EvmChainRepository repository;

  DeleteNetwork(this.repository);

  @override
  Future<Either<Failure, bool>> call(String params) {
    return repository.deleteNetwork(params);
  }
}
