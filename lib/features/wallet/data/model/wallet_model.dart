import 'package:uten_wallet/features/token/data/model/token_model.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required super.id,
    required super.address,
    required super.name,
    required super.network,
    required super.walletType,
    required super.isActive,
    required super.createdAt,
    super.mnemonic,
    super.privateKey,
    super.path,
    super.index,
    super.isBackedUp,
    super.balance,
    super.tokens,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      address: json['address'],
      name: json['name'],
      network: json['network'],
      walletType:
          WalletType.values.firstWhere((e) => e.name == json['walletType']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      mnemonic: json['mnemonic'],
      privateKey: json['privateKey'],
      path: json['path'],
      index: json['index'],
      isBackedUp: json['isBackedUp'] ?? false,
      balance: BigInt.parse(json['balance']),
      tokens:
          (json['tokens'] as List).map((e) => TokenModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'name': name,
      'network': network,
      'walletType': walletType.name,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'mnemonic': mnemonic,
      'privateKey': privateKey,
      'path': path,
      'index': index,
      'isBackedUp': isBackedUp,
      'balance': balance.toString(),
      'tokens': tokens.map((e) => (e as TokenModel).toJson()).toList(),
    };
  }

  factory WalletModel.fromEntity(WalletEntity entity) {
    return WalletModel(
      id: entity.id,
      address: entity.address,
      name: entity.name,
      network: entity.network,
      walletType: entity.walletType,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      mnemonic: entity.mnemonic,
      privateKey: entity.privateKey,
      path: entity.path,
      index: entity.index,
      isBackedUp: entity.isBackedUp,
      balance: entity.balance,
      tokens: entity.tokens,
    );
  }

  WalletModel copyWith({
    String? id,
    String? address,
    String? name,
    String? network,
    WalletType? walletType,
    bool? isActive,
    DateTime? createdAt,
    String? mnemonic,
    String? privateKey,
    String? path,
    int? index,
    bool? isBackedUp,
    BigInt? balance,
    List<TokenEntity>? tokens,
  }) {
    return WalletModel(
      id: id ?? this.id,
      address: address ?? this.address,
      name: name ?? this.name,
      network: network ?? this.network,
      walletType: walletType ?? this.walletType,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      mnemonic: mnemonic ?? this.mnemonic,
      privateKey: privateKey ?? this.privateKey,
      path: path ?? this.path,
      index: index ?? this.index,
      isBackedUp: isBackedUp ?? this.isBackedUp,
      balance: balance ?? this.balance,
      tokens: tokens ?? this.tokens,
    );
  }
}
