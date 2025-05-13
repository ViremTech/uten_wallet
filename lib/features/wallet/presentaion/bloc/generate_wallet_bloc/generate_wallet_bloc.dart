import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/wallet_entity.dart';
import '../../../domain/usecase/generate_wallet.dart';
part 'generate_wallet_event.dart';
part 'generate_wallet_state.dart';

class GenerateWalletBloc
    extends Bloc<GenerateWalletEvent, GenerateWalletState> {
  final GenerateWallet generateWallet;

  GenerateWalletBloc(this.generateWallet) : super(GenerateWalletInitial()) {
    on<GenerateWalletRequested>((event, emit) async {
      emit(GenerateWalletLoading());
      final result = await generateWallet(GenerateWalletParams(
        mnemonic: event.mnemonic,
        network: event.network,
      ));

      result.fold((failure) {
        emit(GenerateWalletFailure(failure.message));
      }, (wallet) {
        emit(GenerateWalletSuccess(wallet));
      });
    });
  }
}
