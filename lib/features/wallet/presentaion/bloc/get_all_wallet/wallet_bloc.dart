import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_all_wallets.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetAllWallets getAllWallets;

  WalletBloc(this.getAllWallets) : super(WalletInitial()) {
    on<FetchAllWallets>(_onFetchAllWallets);
  }

  Future<void> _onFetchAllWallets(
    FetchAllWallets event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());

    final result = await getAllWallets(NoParams());

    result.fold(
      (failure) => emit(WalletError(
        failure.message,
      )),
      (wallets) => emit(WalletLoaded(wallets)),
    );
  }
}
