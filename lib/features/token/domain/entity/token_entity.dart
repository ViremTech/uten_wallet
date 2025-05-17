// features/token/domain/entities/token_entity.dart
import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String contractAddress;
  final int chainId; // Changed to int to match NetworkEntity
  final int decimals;
  final String logoURI;
  final bool isNative;
  final BigInt balance;

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
    );
  }
}
