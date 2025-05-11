// lib/core/network/domain/repository/network_repo.dart

import 'package:dartz/dartz.dart';

import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';

import '../../../error/failure.dart';

abstract class EvmChainRepository {
  Future<Either<Failure, List<NetworkEntity>>> getEvmChains();
  Future<Either<Failure, bool>> addNetwork(NetworkEntity network);
  Future<Either<Failure, bool>> updateNetwork(NetworkEntity network);
  Future<Either<Failure, bool>> deleteNetwork(String networkId);
  Future<Either<Failure, NetworkEntity>> getNetworkById(String networkId);
}
