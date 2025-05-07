import 'package:equatable/equatable.dart';

import '../../../domain/entity/wallet_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final List<WalletEntity> wallets;

  const WalletLoaded(this.wallets);

  @override
  List<Object> get props => [wallets];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object> get props => [message];
}
