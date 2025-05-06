import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';

import '../../../domain/entity/wallet_entity.dart';
import '../../../domain/usecase/get_active_wallet.dart';

part 'get_active_wallet_event.dart';
part 'get_active_wallet_state.dart';

class GetActiveWalletBloc extends Bloc<ActiveWalletEvent, ActiveWalletState> {
  GetActiveWallet getActiveWallet;

  GetActiveWalletBloc({required this.getActiveWallet})
      : super(ActiveWalletInitial()) {
    on<LoadActiveWallet>((event, emit) async {
      emit(ActiveWalletLoading());
      final res = await getActiveWallet(NoParams());

      res.fold(
        (failure) => emit(
          ActiveWalletError(
            failure.message,
          ),
        ),
        (wallet) => emit(
          ActiveWalletLoaded(
            wallet,
          ),
        ),
      );
    });
  }
}
