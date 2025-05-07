import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'persist_event.dart';
part 'persist_state.dart';

class PersistBloc extends Bloc<PersistEvent, PersistState> {
  final FlutterSecureStorage storage;

  PersistBloc(this.storage) : super(WalletInitInitial()) {
    on<CheckSeedPhraseStatus>((event, emit) async {
      emit(WalletInitLoading());

      final activeWallet = await storage.read(key: 'ACTIVE_WALLET_ID');

      if (activeWallet != null && activeWallet.isNotEmpty) {
        emit(WalletReady());
      } else {
        emit(WalletNeedsSetup());
      }
    });
  }
}
