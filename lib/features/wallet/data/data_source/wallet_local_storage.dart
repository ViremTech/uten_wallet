import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';

import '../../../token/data/model/token_model.dart';

abstract class WalletLocalStorage {
  Future<void> saveMnemonic(String mnemonic);
  Future<String?> getMnemonic();
  Future<void> saveWallet(WalletModel wallet);
  Future<List<WalletModel>> getAllWallets();
  Future<void> setActiveWallet(String walletId);
  Future<void> deleteWallet(String walletId);
  Future<void> updateWallet(WalletModel wallet);
  Future<WalletModel?> getActiveWallet();
  Future<void> updateNetwork(String network);
  Future<void> addTokenToWallet(String walletId, TokenModel token);
  Future<void> removeTokenFromWallet(
      String walletId, String tokenContractAddress);
  Future<List<TokenModel>> getWalletTokens(String walletId, {int? chainId});
}

class WalletLocalStorageImpl implements WalletLocalStorage {
  final FlutterSecureStorage storage;

  WalletLocalStorageImpl({required this.storage});

  static const _mnemonicKey = 'WALLET_MNEMONIC';
  static const _activeWalletKey = 'ACTIVE_WALLET_ID';

  @override
  Future<void> saveMnemonic(String mnemonic) async {
    await storage.write(key: _mnemonicKey, value: mnemonic);
  }

  @override
  Future<String?> getMnemonic() async {
    return await storage.read(key: _mnemonicKey);
  }

  @override
  Future<void> saveWallet(WalletModel wallet) async {
    final jsonString = jsonEncode(wallet.toJson());
    await storage.write(key: 'wallet_data_${wallet.id}', value: jsonString);
  }

  @override
  Future<List<WalletModel>> getAllWallets() async {
    final all = await storage.readAll();
    final wallets = all.entries
        .where((e) => e.key.startsWith('wallet_data_'))
        .map((e) => WalletModel.fromJson(jsonDecode(e.value)))
        .toList();
    return wallets;
  }

  @override
  Future<void> setActiveWallet(String walletId) async {
    final allWallets = await getAllWallets();

    for (final wallet in allWallets) {
      final shouldBeActive = wallet.id == walletId;
      if (wallet.isActive != shouldBeActive) {
        final updated = wallet.copyWith(isActive: shouldBeActive);
        await saveWallet(updated);
      }
    }

    await storage.write(key: _activeWalletKey, value: walletId);
  }

  @override
  Future<WalletModel?> getActiveWallet() async {
    final activeWalletId = await storage.read(key: _activeWalletKey);
    if (activeWalletId == null) return null;
    final jsonString = await storage.read(key: 'wallet_data_$activeWalletId');
    if (jsonString == null) return null;
    return WalletModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    await storage.delete(key: 'wallet_data_$walletId');
    final activeId = await storage.read(key: _activeWalletKey);
    if (activeId == walletId) {
      await storage.delete(key: _activeWalletKey);
    }
  }

  @override
  Future<void> updateWallet(WalletModel wallet) async {
    await saveWallet(wallet);
  }

  @override
  Future<void> updateNetwork(String network) async {
    final wallet = await getActiveWallet();
    await updateWallet(wallet!.copyWith(network: network));
  }

  @override
  Future<void> addTokenToWallet(String walletId, TokenModel token) async {
    final walletJson = await storage.read(key: 'wallet_data_$walletId');
    if (walletJson == null) throw Exception('Wallet not found');

    final wallet = WalletModel.fromJson(jsonDecode(walletJson));

    // Check for duplicate tokens
    if (wallet.tokens.any((t) =>
        t.contractAddress == token.contractAddress &&
        t.chainId == token.chainId)) {
      throw Exception('Token already exists in wallet');
    }

    final updatedWallet = wallet.copyWith(
      tokens: [...wallet.tokens, token],
    );

    await storage.write(
      key: 'wallet_data_$walletId',
      value: jsonEncode(updatedWallet.toJson()),
    );
  }

  @override
  Future<void> removeTokenFromWallet(
      String walletId, String tokenContractAddress) async {
    final walletJson = await storage.read(key: 'wallet_data_$walletId');
    if (walletJson == null) throw Exception('Wallet not found');

    final wallet = WalletModel.fromJson(jsonDecode(walletJson));
    final updatedTokens = wallet.tokens
        .where((token) => token.contractAddress != tokenContractAddress)
        .toList();

    final updatedWallet = wallet.copyWith(tokens: updatedTokens);
    await saveWallet(updatedWallet);
  }

  @override
  Future<List<TokenModel>> getWalletTokens(String walletId,
      {int? chainId}) async {
    final walletJson = await storage.read(key: 'wallet_data_$walletId');
    if (walletJson == null) throw Exception('Wallet not found');

    final wallet = WalletModel.fromJson(jsonDecode(walletJson));

    // Filter by chainId if provided
    final tokens = chainId != null
        ? wallet.tokens.where((t) => t.chainId == chainId).toList()
        : wallet.tokens;

    return tokens.cast<TokenModel>();
  }
}
