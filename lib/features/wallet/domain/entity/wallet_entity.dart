import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

enum WalletType { generated, imported, hardware }

class WalletEntity {
  final String id;
  final String address;
  final String name;
  final String network;
  final WalletType walletType;
  final bool isActive;
  final DateTime createdAt;
  final String? mnemonic;
  final String? privateKey;
  final String? path;
  final int? index;
  final bool isBackedUp;
  final BigInt balance;
  final List<TokenEntity> tokens;

  WalletEntity({
    required this.id,
    required this.address,
    required this.name,
    required this.network,
    required this.walletType,
    required this.isActive,
    required this.createdAt,
    this.mnemonic,
    this.privateKey,
    this.path,
    this.index,
    this.isBackedUp = false,
    BigInt? balance,
    this.tokens = const [],
  }) : balance = balance ?? BigInt.zero;
}
