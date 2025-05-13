part of 'set_active_wallet_bloc.dart';

abstract class SetMyActiveWalletState extends Equatable {
  const SetMyActiveWalletState();

  @override
  List<Object> get props => [];
}

class SetMyActiveWalletInitial extends SetMyActiveWalletState {}

class SetMyActiveWalletInProgress extends SetMyActiveWalletState {}

class SetMyActiveWalletSuccess extends SetMyActiveWalletState {
  final String activeWalletId;
  final String walletName;

  const SetMyActiveWalletSuccess(this.activeWalletId, this.walletName);

  @override
  List<Object> get props => [activeWalletId];
}

class SetMyActiveWalletFailure extends SetMyActiveWalletState {
  final String message;

  const SetMyActiveWalletFailure(this.message);

  @override
  List<Object> get props => [message];
}
