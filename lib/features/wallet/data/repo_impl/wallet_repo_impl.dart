import 'package:convert/convert.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:uten_wallet/core/error/failure.dart';

import 'package:uten_wallet/features/wallet/data/data_source/wallet_local_storage.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/domain/repository/wallet_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';

import '../../../../core/network/data/data_source/local_data_source/local_data_source.dart';
import '../../../../core/network/data/model/network_model.dart';

class WalletRepoImpl implements WalletRepo {
  final WalletLocalStorage localStorage;
  final EvmChainLocalDataSource evmChainLocalDataSource;

  WalletRepoImpl({
    required this.localStorage,
    required this.evmChainLocalDataSource,
  });

  @override
  Future<Either<Failure, String>> generateMnemonic() async {
    try {
      final mnemonic = bip39.generateMnemonic();
      await localStorage.saveMnemonic(mnemonic);
      return right(mnemonic);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletEntity>> generateWallet({
    required String mnemonic,
    required String name,
    required String network,
  }) async {
    List<NetworkModel> cacheEvmChains =
        await evmChainLocalDataSource.getCachedEvmChains();
    try {
      if (!bip39.validateMnemonic(mnemonic)) {
        return left(Failure("Invalid mnemonic"));
      }
      final seed = bip39.mnemonicToSeed(mnemonic);

      final root = bip32.BIP32.fromSeed(seed);
      final path = "m/44'/60'/0'/0/0";
      final childKey = root.derivePath(path);
      final privateKey = childKey.privateKey;
      if (privateKey == null) {
        return Left(Failure("Private key derivation failed"));
      }
      final hexPrivateKey = hex.encode(privateKey);
      final credentials = EthPrivateKey.fromHex(hexPrivateKey);
      final address = credentials.address;

      if (cacheEvmChains.any((model) => model.id.contains(network))) {
        return Left(Failure("Unsupported network"));
      }

      final wallet = WalletModel(
        mnemonic: mnemonic,
        id: const Uuid().v4(),
        address: address.hexEip55,
        name: name,
        network: network,
        walletType: WalletType.generated,
        isActive: false,
        createdAt: DateTime.now(),
        privateKey: hexPrivateKey,
        path: path,
        index: 0,
        balance: BigInt.zero,
        tokens: [],
      );

      await localStorage.saveWallet(wallet);
      await localStorage.setActiveWallet(wallet.id);
      return right(wallet);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance() async {
    List<NetworkModel> cacheEvmChains =
        await evmChainLocalDataSource.getCachedEvmChains();
    try {
      final wallet = await localStorage.getActiveWallet();
      if (wallet == null) {
        return left(Failure('No active wallet found'));
      }

      final rpcUrls = cacheEvmChains
          .firstWhere((network) => network.id == wallet.network)
          .rpc
          .first;
      if (rpcUrls.isNotEmpty) {
        return left(Failure('Unsupported network'));
      }

      final client = Web3Client(rpcUrls, http.Client());
      final address = EthereumAddress.fromHex(wallet.address);
      final ethBalance = await client.getBalance(address);
      BigInt totalBalance = ethBalance.getInWei;

      for (final token in wallet.tokens) {
        totalBalance += token.balance;
      }

      final totalInEth = totalBalance / BigInt.from(10).pow(18);
      return right(totalInEth.toDouble());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWallet(String walletId) async {
    try {
      await localStorage.deleteWallet(walletId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletEntity?>> getActiveWallet() async {
    try {
      final wallet = await localStorage.getActiveWallet();
      if (wallet == null) return left(Failure("No active wallet found"));
      return right(wallet);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletEntity>>> getAllWallets() async {
    try {
      final wallets = await localStorage.getAllWallets();
      return right(wallets);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletEntity>> importWallet({
    required String privateKey,
    required String name,
    required String network,
  }) async {
    List<NetworkModel> cacheEvmChains =
        await evmChainLocalDataSource.getCachedEvmChains();
    try {
      if (cacheEvmChains.any((model) => model.id.contains(network))) {
        return Left(Failure("Unsupported network"));
      }

      final credentials = EthPrivateKey.fromHex(privateKey);
      final address = credentials.address.hexEip55;
      final wallet = WalletModel(
        mnemonic: null,
        id: const Uuid().v4(),
        address: address,
        name: name,
        network: network,
        walletType: WalletType.imported,
        isActive: false,
        createdAt: DateTime.now(),
        privateKey: privateKey,
        path: null,
        index: null,
        balance: BigInt.zero,
        tokens: [],
      );
      await localStorage.saveWallet(wallet);
      await localStorage.setActiveWallet(wallet.id);
      return right(wallet);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setActiveWallet(String walletId) async {
    try {
      await localStorage.setActiveWallet(walletId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWallet(WalletEntity wallet) async {
    try {
      await localStorage.updateWallet(WalletModel.fromEntity(wallet));
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWalletNetwork(String network) async {
    try {
      await localStorage.updateNetwork(network);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
