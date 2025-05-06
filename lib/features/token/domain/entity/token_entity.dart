class TokenEntity {
  final String id;
  final String name;
  final String symbol;
  final String address;
  final int decimals;
  final BigInt balance;
  final String network;
  final int chainId;
  final bool isNative;
  final double priceUsd;
  final String? logoUrl;
  final bool isCustom;
  final DateTime updatedAt;

  TokenEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.address,
    required this.decimals,
    required this.balance,
    required this.network,
    required this.chainId,
    required this.isNative,
    required this.priceUsd,
    this.logoUrl,
    this.isCustom = false,
    required this.updatedAt,
  });

  double get balanceInDecimal => balance / BigInt.from(10).pow(decimals);

  double get totalValueUsd => balanceInDecimal * priceUsd;
}
