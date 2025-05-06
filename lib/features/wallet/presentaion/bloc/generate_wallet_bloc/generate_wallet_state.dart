part of 'generate_wallet_bloc.dart';

@immutable
abstract class GenerateWalletState {}

class GenerateWalletInitial extends GenerateWalletState {}

class GenerateWalletLoading extends GenerateWalletState {}

class GenerateWalletSuccess extends GenerateWalletState {
  final WalletEntity wallet;
  GenerateWalletSuccess(this.wallet);
}

class GenerateWalletFailure extends GenerateWalletState {
  final String message;
  GenerateWalletFailure(this.message);
}
