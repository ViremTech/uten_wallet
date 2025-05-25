// features/token/domain/entities/token_entity.dart
import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String id;
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

  // Helper method to check if price data is stale (older than 5 minutes)
  bool get isStale {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!).inMinutes > 5;
  }
}
