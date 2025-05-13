part of 'delete_wallet_bloc.dart';

abstract class DeleteWalletState extends Equatable {
  const DeleteWalletState();

  @override
  List<Object?> get props => [];
}

class DeleteWalletInitial extends DeleteWalletState {}

class DeleteWalletLoading extends DeleteWalletState {}

class DeleteWalletSuccess extends DeleteWalletState {}

class DeleteWalletFailure extends DeleteWalletState {
  final String message;

  const DeleteWalletFailure(this.message);

  @override
  List<Object?> get props => [message];
}
