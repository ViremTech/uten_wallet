part of 'evmchain_bloc.dart';

abstract class EvmChainState extends Equatable {
  const EvmChainState();

  @override
  List<Object?> get props => [];
}

class EvmChainInitialState extends EvmChainState {}

class EvmChainLoadingState extends EvmChainState {}

class EvmChainLoadedState extends EvmChainState {
  final List<NetworkEntity> chains;

  const EvmChainLoadedState(this.chains);

  @override
  List<Object?> get props => [chains];
}

class EvmChainLoadedByIdState extends EvmChainState {
  final NetworkEntity chain;

  const EvmChainLoadedByIdState(this.chain);

  @override
  List<Object?> get props => [chain];
}

class EvmChainErrorState extends EvmChainState {
  final String message;

  const EvmChainErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkOperationSuccessState extends EvmChainState {
  final String message;

  const NetworkOperationSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}
