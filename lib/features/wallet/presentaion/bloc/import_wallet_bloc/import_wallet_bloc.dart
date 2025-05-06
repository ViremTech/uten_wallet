import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/wallet_entity.dart';
import '../../../domain/usecase/import_wallet.dart';

part 'import_wallet_event.dart';
part 'import_wallet_state.dart';

class ImportWalletBloc extends Bloc<ImportWalletEvent, ImportWalletState> {
  final ImportWallet importWallet;

  ImportWalletBloc(this.importWallet) : super(ImportWalletInitial()) {
    on<ImportWalletRequested>((event, emit) async {
      emit(ImportWalletLoading());
      final result = await importWallet(ImportWalletParams(
        privateKey: event.privateKey,
        name: event.name,
        network: event.network,
      ));
      result.fold(
        (failure) => emit(ImportWalletFailure(failure.message)),
        (wallet) => emit(ImportWalletSuccess(wallet)),
      );
    });
  }
}
