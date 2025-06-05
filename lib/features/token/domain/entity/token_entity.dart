import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String id;
  final String code;
  final String name;
  final String symbol;
  final String contractAddress;
  final int chainId;
  final int decimals;
  final String logoURI;
  final bool isNative;
  final BigInt balance;
  final TokenPrice tokenPrice;
  final String? coinGeckoId; // Added CoinGecko ID for better price lookup

  const TokenEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.contractAddress,
    required this.chainId,
    required this.decimals,
    required this.logoURI,
    this.isNative = false,
    required this.balance,
    required this.tokenPrice,
    this.coinGeckoId, // Optional CoinGecko ID
  });

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        contractAddress,
        chainId,
        decimals,
        logoURI,
        isNative,
        balance,
        tokenPrice,
        coinGeckoId,
      ];

  TokenEntity copyWith({
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
  }) {
    return TokenEntity(
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
    );
  }
}

class TokenPrice extends Equatable {
  final double usdPrice;
  final double precentageChange;
  final double totalUserValueUsd;
  final DateTime? lastUpdated; // Added timestamp for cache management

  const TokenPrice({
    required this.usdPrice,
    required this.precentageChange,
    required this.totalUserValueUsd,
    this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        usdPrice,
        precentageChange,
        totalUserValueUsd,
        lastUpdated,
      ];

  TokenPrice copyWith({
    double? usdPrice,
    double? precentageChange,
    double? totalUserValueUsd,
    DateTime? lastUpdated,
  }) {
    return TokenPrice(
      usdPrice: usdPrice ?? this.usdPrice,
      precentageChange: precentageChange ?? this.precentageChange,
      totalUserValueUsd: totalUserValueUsd ?? this.totalUserValueUsd,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  static TokenPrice zero() {
    return TokenPrice(
        usdPrice: 0.0,
        precentageChange: 0.0,
        totalUserValueUsd: 0.0,
        lastUpdated: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'usdPrice': usdPrice,
      'precentageChange': precentageChange,
      'totalUserValueUsd': totalUserValueUsd,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory TokenPrice.fromJson(Map<String, dynamic> json) {
    return TokenPrice(
      usdPrice: (json['usdPrice'] ?? 0.0).toDouble(),
      precentageChange: (json['precentageChange'] ?? 0.0).toDouble(),
      totalUserValueUsd: (json['totalUserValueUsd'] ?? 0.0).toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.tryParse(json['lastUpdated'])
          : null,
    );
  }

  // Helper method to check if price data is stale (older than 5 minutes)
  bool get isStale {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!).inMinutes > 1;
  }
}
