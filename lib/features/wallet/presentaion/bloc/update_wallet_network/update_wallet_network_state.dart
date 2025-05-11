part of 'update_wallet_network_bloc.dart';

abstract class WalletNetworkState {}

class WalletNetworkInitial extends WalletNetworkState {}

class WalletLoading extends WalletNetworkState {}

class WalletNetworkUpdated extends WalletNetworkState {}

class WalletError extends WalletNetworkState {
  final String message;

  WalletError(this.message);
}
