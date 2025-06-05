// features/token/data/models/token_model.dart
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
    required super.tokenPrice,
    super.coinGeckoId, // Added CoinGecko ID support
    this.usdPrice,
    required super.code, // Keep for backward compatibility if needed
  });

  final String? usdPrice; // Deprecated, use tokenPrice.usdPrice instead

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
      coinGeckoId:
          json['coinGeckoId'] ?? json['coingecko_id'], // Support both formats
      usdPrice: json['usd']?.toString(),
      tokenPrice: TokenPrice(
        usdPrice: _parseDouble(json['usdPrice'] ?? json['usd'] ?? 0),
        precentageChange: _parseDouble(
            json['precentageChange'] ?? json['price_24h_change'] ?? 0),
        totalUserValueUsd: _parseDouble(json['totalUserValueUsd'] ?? 0),
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.tryParse(json['lastUpdated'].toString())
            : DateTime.now(),
      ),
      code: json['code'] ?? '',
    );
  }

  // Helper method to safely parse double from various types
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'address': contractAddress,
      'contractAddress': contractAddress,
      'chainId': chainId,
      'decimals': decimals,
      'icon': logoURI,
      'logoURI': logoURI,
      'isNative': isNative,
      'balance': balance.toString(),
      'coinGeckoId': coinGeckoId,
      'usdPrice': tokenPrice.usdPrice,
      'precentageChange': tokenPrice.precentageChange,
      'totalUserValueUsd': tokenPrice.totalUserValueUsd,
      'lastUpdated': tokenPrice.lastUpdated?.toIso8601String(),
      // Keep backward compatibility
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
      tokenPrice: entity.tokenPrice,
      coinGeckoId: entity.coinGeckoId,
      code: entity.code,
    );
  }

  // Helper method to get chainId from chain name
  static int? _getChainIdFromName(String? chainName) {
    if (chainName == null) return null;

    final chainMap = {
      'eth': 1,
      'ethereum': 1,
      'bsc': 56,
      'binance-smart-chain': 56,
      'polygon': 137,
      'matic': 137,
      'arbitrum': 42161,
      'arbitrum-one': 42161,
      'optimism': 10,
      'optimistic-ethereum': 10,
      'avax': 43114,
      'avalanche': 43114,
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
    String? code,
    String? name,
    String? symbol,
    String? contractAddress,
    int? chainId,
    int? decimals,
    String? logoURI,
    bool? isNative,
    BigInt? balance,
    TokenPrice? tokenPrice,
    String? coinGeckoId,
    String? usdPrice,
  }) {
    return TokenModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      contractAddress: contractAddress ?? this.contractAddress,
      chainId: chainId ?? this.chainId,
      decimals: decimals ?? this.decimals,
      logoURI: logoURI ?? this.logoURI,
      isNative: isNative ?? this.isNative,
      balance: balance ?? this.balance,
      tokenPrice: tokenPrice ?? this.tokenPrice,
      coinGeckoId: coinGeckoId ?? this.coinGeckoId,
      usdPrice: usdPrice ?? this.usdPrice,
    );
  }

  // Helper method to create a TokenModel with updated price
  TokenModel updatePrice({
    required double usdPrice,
    required double precentageChange,
    required double totalUserValueUsd,
  }) {
    return copyWith(
      tokenPrice: TokenPrice(
        usdPrice: usdPrice,
        precentageChange: precentageChange,
        totalUserValueUsd: totalUserValueUsd,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // Helper method to check if token needs price update
  bool get needsPriceUpdate {
    return tokenPrice.isStale;
  }
}
