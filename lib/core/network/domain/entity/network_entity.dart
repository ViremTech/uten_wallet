import 'package:equatable/equatable.dart';

class NetworkEntity extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final int chainId;
  final List<String> rpc;
  final String currencySymbol;
  final String currencyName;
  final int decimals;
  final String logoUrl;
  final String blockExplorerUrl;
  final bool isTestnet;
  final bool isEditable;

  const NetworkEntity({
    required this.id,
    required this.name,
    required this.shortName,
    required this.chainId,
    required this.rpc,
    required this.currencySymbol,
    required this.currencyName,
    this.decimals = 18,
    this.logoUrl = '',
    required this.blockExplorerUrl,
    this.isTestnet = false,
    this.isEditable = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        shortName,
        chainId,
        rpc,
        currencySymbol,
        currencyName,
        decimals,
        logoUrl,
        blockExplorerUrl,
        isTestnet,
        isEditable,
      ];
}

// For backward compatibility with your existing code
typedef EvmChainEntity = NetworkEntity;
