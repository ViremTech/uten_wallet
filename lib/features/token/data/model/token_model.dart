import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';

class TokenModel extends TokenEntity {
  TokenModel({
    required String id,
    required String name,
    required String symbol,
    required String address,
    required int decimals,
    required BigInt balance,
    required String network,
    required int chainId,
    required bool isNative,
    required double priceUsd,
    String? logoUrl,
    bool isCustom = false,
    required DateTime updatedAt,
  }) : super(
          id: id,
          name: name,
          symbol: symbol,
          address: address,
          decimals: decimals,
          balance: balance,
          network: network,
          chainId: chainId,
          isNative: isNative,
          priceUsd: priceUsd,
          logoUrl: logoUrl,
          isCustom: isCustom,
          updatedAt: updatedAt,
        );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      address: json['address'],
      decimals: json['decimals'],
      balance: BigInt.parse(json['balance']),
      network: json['network'],
      chainId: json['chainId'],
      isNative: json['isNative'],
      priceUsd: (json['priceUsd'] as num).toDouble(),
      logoUrl: json['logoUrl'],
      isCustom: json['isCustom'] ?? false,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'address': address,
      'decimals': decimals,
      'balance': balance.toString(),
      'network': network,
      'chainId': chainId,
      'isNative': isNative,
      'priceUsd': priceUsd,
      'logoUrl': logoUrl,
      'isCustom': isCustom,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
