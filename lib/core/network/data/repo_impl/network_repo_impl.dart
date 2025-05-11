// lib/core/network/data/repo_impl/network_repo_impl.dart

import 'package:dartz/dartz.dart';

import 'package:uten_wallet/core/network/data/data_source/local_data_source/local_data_source.dart';
import 'package:uten_wallet/core/network/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:uten_wallet/core/network/data/model/network_model.dart';
import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/domain/repository/network_repo.dart';
import 'package:uten_wallet/core/network_info/network_info.dart';

import '../../../error/exception.dart';
import '../../../error/failure.dart';

class EvmChainRepositoryImpl implements EvmChainRepository {
  final EvmChainRemoteDataSource remoteDataSource;
  final EvmChainLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EvmChainRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NetworkEntity>>> getEvmChains() async {
    try {
      if (await networkInfo.isConnected) {
        try {
          final remoteNetworks = await remoteDataSource.getEvmChains();
          await localDataSource.cacheEvmChains(remoteNetworks);
          final cachedNetworks = await localDataSource.getCachedEvmChains();
          return Right(cachedNetworks);
        } on ServerException {
          // If server fetch fails, try to get cached networks
          final cachedNetworks = await localDataSource.getCachedEvmChains();
          return Right(cachedNetworks);
        }
      } else {
        // No internet connection, get from local cache
        final cachedNetworks = await localDataSource.getCachedEvmChains();
        return Right(cachedNetworks);
      }
    } on CacheException {
      return Left(CacheFailure('Failed to retrieve networks from cache'));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> addNetwork(NetworkEntity network) async {
    try {
      final networkModel = NetworkModel(
        id: network.id,
        name: network.name,
        shortName: network.shortName,
        chainId: network.chainId,
        rpc: network.rpc,
        currencySymbol: network.currencySymbol,
        currencyName: network.currencyName,
        decimals: network.decimals,
        logoUrl: network.logoUrl,
        blockExplorerUrl: network.blockExplorerUrl,
        isTestnet: network.isTestnet,
        // Custom networks are always editable
        isEditable: true,
      );

      final result = await localDataSource.addNetwork(networkModel);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure('Failed to add network to cache'));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateNetwork(NetworkEntity network) async {
    try {
      final networkModel = NetworkModel(
        id: network.id,
        name: network.name,
        shortName: network.shortName,
        chainId: network.chainId,
        rpc: network.rpc,
        currencySymbol: network.currencySymbol,
        currencyName: network.currencyName,
        decimals: network.decimals,
        logoUrl: network.logoUrl,
        blockExplorerUrl: network.blockExplorerUrl,
        isTestnet: network.isTestnet,
        isEditable: network.isEditable,
      );

      final result = await localDataSource.updateNetwork(networkModel);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure('Failed to update network in cache'));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNetwork(String networkId) async {
    try {
      final result = await localDataSource.deleteNetwork(networkId);
      return Right(result);
    } on CacheException {
      return Left(CacheFailure('Failed to delete network from cache'));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, NetworkEntity>> getNetworkById(
      String networkId) async {
    try {
      final network = await localDataSource.getNetworkById(networkId);
      return Right(network);
    } on CacheException {
      return Left(CacheFailure('Failed to retrieve network from cache'));
    } catch (e) {
      return Left(
          ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
