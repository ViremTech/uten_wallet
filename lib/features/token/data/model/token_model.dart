import '../../domain/entity/token_entity.dart';

class TokenModel extends TokenEntity {
  const TokenModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.contractAddress,
    required super.chainId,
    required super.decimals,
    required super.logoURI,
    super.isNative = false,
    required super.balance,
    this.usdPrice,
  });

  final String? usdPrice;

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    // Determine chainId from chain name if chainId is null
    final chainId = json['chainId'] ?? _getChainIdFromName(json['chain']);

    return TokenModel(
      id: json['id']?.toString() ?? json['address'] ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      contractAddress: json['address'] ?? json['contractAddress'] ?? '',
      chainId: chainId != null ? int.parse(chainId.toString()) : 0,
      decimals: json['decimals'] ?? 18, // Default to 18 if not provided
      logoURI: json['icon'] ?? json['logoURI'] ?? '',
      isNative: json['isNative'] ?? false,
      balance: BigInt.parse(json['balance']?.toString() ?? '0'),
      usdPrice: json['usd']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'address': contractAddress,
      'contractAddress': contractAddress,
      'chainId': chainId,
      'decimals': decimals,
      'icon': logoURI,
      'isNative': isNative,
      'balance': balance.toString(),
      if (usdPrice != null) 'usd': usdPrice,
    };
  }

  factory TokenModel.fromEntity(TokenEntity entity) {
    return TokenModel(
      id: entity.id,
      name: entity.name,
      symbol: entity.symbol,
      contractAddress: entity.contractAddress,
      chainId: entity.chainId,
      decimals: entity.decimals,
      logoURI: entity.logoURI,
      isNative: entity.isNative,
      balance: entity.balance,
    );
  }

  // Helper method to get chainId from chain name
  static int? _getChainIdFromName(String? chainName) {
    if (chainName == null) return null;

    final chainMap = {
      'eth': 1,
      'bsc': 56,
      'polygon': 137,
      'arbitrum': 42161,
      'optimism': 10,
      'avax': 43114,
      'fantom': 250,
      'cronos': 25,
      'klaytn': 8217,
      'celo': 42220,
    };

    return chainMap[chainName.toLowerCase()];
  }

  @override
  TokenModel copyWith({
    String? id,
    String? name,
    String? symbol,
    String? contractAddress,
    int? chainId,
    int? decimals,
    String? logoURI,
    bool? isNative,
    BigInt? balance,
    String? usdPrice,
  }) {
    return TokenModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      contractAddress: contractAddress ?? this.contractAddress,
      chainId: chainId ?? this.chainId,
      decimals: decimals ?? this.decimals,
      logoURI: logoURI ?? this.logoURI,
      isNative: isNative ?? this.isNative,
      balance: balance ?? this.balance,
      usdPrice: usdPrice ?? this.usdPrice,
    );
  }
}
