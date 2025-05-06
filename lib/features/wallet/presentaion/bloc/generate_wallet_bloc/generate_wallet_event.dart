part of 'generate_wallet_bloc.dart';

@immutable
abstract class GenerateWalletEvent {}

class GenerateWalletRequested extends GenerateWalletEvent {
  final String mnemonic;
  final String name;
  final String network;

  GenerateWalletRequested({
    required this.mnemonic,
    required this.name,
    required this.network,
  });
}
