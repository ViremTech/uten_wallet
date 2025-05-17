part of 'evmchain_bloc.dart';

abstract class EvmChainEvent extends Equatable {
  const EvmChainEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvmChainsEvent extends EvmChainEvent {}

class AddNetworkEvent extends EvmChainEvent {
  final NetworkEntity network;

  const AddNetworkEvent(this.network);

  @override
  List<Object?> get props => [network];
}

class UpdateNetworkEvent extends EvmChainEvent {
  final NetworkEntity network;

  const UpdateNetworkEvent(this.network);

  @override
  List<Object?> get props => [network];
}

class DeleteNetworkEvent extends EvmChainEvent {
  final String networkId;

  const DeleteNetworkEvent(this.networkId);

  @override
  List<Object?> get props => [networkId];
}

class GetNetworkById extends EvmChainEvent {
  final String networkId;

  const GetNetworkById({required this.networkId});
  @override
  List<Object?> get props => [networkId];
}
