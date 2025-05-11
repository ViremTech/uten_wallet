import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecase/update_wallet_network.dart';

part 'update_wallet_network_event.dart';
part 'update_wallet_network_state.dart';

class WalletNetworkBloc extends Bloc<WalletNetworkEvent, WalletNetworkState> {
  final UpdateWalletNetwork updateWalletNetwork;

  WalletNetworkBloc(this.updateWalletNetwork) : super(WalletNetworkInitial()) {
    on<UpdateWalletNetworkEvent>(_onUpdateWalletNetwork);
  }

  Future<void> _onUpdateWalletNetwork(
    UpdateWalletNetworkEvent event,
    Emitter<WalletNetworkState> emit,
  ) async {
    emit(WalletLoading());

    final result = await updateWalletNetwork(event.network);

    result.fold(
      (failure) => emit(WalletError(_mapFailureToMessage(failure))),
      (_) => emit(WalletNetworkUpdated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
