part of 'delete_wallet_bloc.dart';

abstract class DeleteWalletEvent extends Equatable {
  const DeleteWalletEvent();

  @override
  List<Object?> get props => [];
}

class DeleteWalletRequested extends DeleteWalletEvent {
  final String walletId;

  const DeleteWalletRequested(this.walletId);

  @override
  List<Object?> get props => [walletId];
}
