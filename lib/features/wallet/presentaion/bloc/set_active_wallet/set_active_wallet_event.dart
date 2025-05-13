part of 'set_active_wallet_bloc.dart';

abstract class SetMyActiveWalletEvent extends Equatable {
  const SetMyActiveWalletEvent();

  @override
  List<Object> get props => [];
}

class SetActiveWalletRequested extends SetMyActiveWalletEvent {
  final String walletId;
  final String walletName;

  const SetActiveWalletRequested(this.walletId, this.walletName);

  @override
  List<Object> get props => [walletId];
}
