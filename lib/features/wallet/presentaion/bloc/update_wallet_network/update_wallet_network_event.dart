part of 'update_wallet_network_bloc.dart';

abstract class WalletNetworkEvent {}

class UpdateWalletNetworkEvent extends WalletNetworkEvent {
  final String network;

  UpdateWalletNetworkEvent(this.network);
}
