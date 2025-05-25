import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/set_active_wallet.dart';

part 'set_active_wallet_event.dart';
part 'set_active_wallet_state.dart';

class SetMyActiveWalletBloc
    extends Bloc<SetMyActiveWalletEvent, SetMyActiveWalletState> {
  final SetActiveWallet setActiveWalletUseCase;

  SetMyActiveWalletBloc({required this.setActiveWalletUseCase})
      : super(SetMyActiveWalletInitial()) {
    on<SetActiveWalletRequested>(_onSetActiveWalletRequested);
  }

  Future<void> _onSetActiveWalletRequested(
    SetActiveWalletRequested event,
    Emitter<SetMyActiveWalletState> emit,
  ) async {
    emit(SetMyActiveWalletInProgress());
    final result = await setActiveWalletUseCase(
      SetActiveWalletParams(event.walletId),
    );

    result.fold(
      (failure) => emit(SetMyActiveWalletFailure(failure.toString())),
      (_) => emit(SetMyActiveWalletSuccess(event.walletId, event.walletName)),
    );
  }
}
