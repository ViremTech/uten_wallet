part of 'import_wallet_bloc.dart';

@immutable
abstract class ImportWalletState {}

class ImportWalletInitial extends ImportWalletState {}

class ImportWalletLoading extends ImportWalletState {}

class ImportWalletSuccess extends ImportWalletState {
  final WalletEntity wallet;
  ImportWalletSuccess(this.wallet);
}

class ImportWalletFailure extends ImportWalletState {
  final String message;
  ImportWalletFailure(this.message);
}
