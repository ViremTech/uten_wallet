import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';

class NetworkModel extends NetworkEntity {
  const NetworkModel({
    required super.id,
    required super.name,
    required super.shortName,
    required super.chainId,
    required super.rpc,
    required super.currencySymbol,
    required super.currencyName,
    super.decimals,
    super.logoUrl,
    required super.blockExplorerUrl,
    super.isTestnet,
    super.isEditable,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? '',
      chainId: json['chainId'] ?? 0,
      rpc: List<String>.from(json['rpc'] ?? []),
      currencySymbol: json['currencySymbol'] ?? '',
      currencyName: json['currencyName'] ?? '',
      decimals: json['decimals'] ?? 18,
      logoUrl: json['logoUrl'] ?? '',
      blockExplorerUrl: json['blockExplorerUrl'] ?? '',
      isTestnet: json['isTestnet'] ?? false,
      isEditable: json['isEditable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'chainId': chainId,
      'rpc': rpc,
      'currencySymbol': currencySymbol,
      'currencyName': currencyName,
      'decimals': decimals,
      'logoUrl': logoUrl,
      'blockExplorerUrl': blockExplorerUrl,
      'isTestnet': isTestnet,
      'isEditable': isEditable,
    };
  }

  NetworkModel copyWith({
    String? id,
    String? name,
    String? shortName,
    int? chainId,
    List<String>? rpc,
    String? currencySymbol,
    String? currencyName,
    int? decimals,
    String? logoUrl,
    String? blockExplorerUrl,
    bool? isTestnet,
    bool? isEditable,
  }) {
    return NetworkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      chainId: chainId ?? this.chainId,
      rpc: rpc ?? this.rpc,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyName: currencyName ?? this.currencyName,
      decimals: decimals ?? this.decimals,
      logoUrl: logoUrl ?? this.logoUrl,
      blockExplorerUrl: blockExplorerUrl ?? this.blockExplorerUrl,
      isTestnet: isTestnet ?? this.isTestnet,
      isEditable: isEditable ?? this.isEditable,
    );
  }
}

// For backward compatibility with your existing code
typedef EvmChainModel = NetworkModel;
