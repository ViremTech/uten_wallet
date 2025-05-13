import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/delete_wallet.dart';

part 'delete_wallet_event.dart';
part 'delete_wallet_state.dart';

class DeleteWalletBloc extends Bloc<DeleteWalletEvent, DeleteWalletState> {
  final DeleteWallet deleteWallet;

  DeleteWalletBloc(this.deleteWallet) : super(DeleteWalletInitial()) {
    on<DeleteWalletRequested>(_onDeleteWalletRequested);
  }

  Future<void> _onDeleteWalletRequested(
    DeleteWalletRequested event,
    Emitter<DeleteWalletState> emit,
  ) async {
    emit(DeleteWalletLoading());

    final result = await deleteWallet(DeleteWalletParams(event.walletId));

    result.fold(
      (failure) => emit(DeleteWalletFailure(failure.message)),
      (_) => emit(DeleteWalletSuccess()),
    );
  }
}
