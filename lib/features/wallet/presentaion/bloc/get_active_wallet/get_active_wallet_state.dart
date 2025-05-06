part of 'get_active_wallet_bloc.dart';

@immutable
abstract class ActiveWalletState {}

class ActiveWalletInitial extends ActiveWalletState {}

class ActiveWalletLoading extends ActiveWalletState {}

class ActiveWalletLoaded extends ActiveWalletState {
  final WalletEntity? wallet;

  ActiveWalletLoaded(this.wallet);
}

class ActiveWalletError extends ActiveWalletState {
  final String message;

  ActiveWalletError(this.message);
}
