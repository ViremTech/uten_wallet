part of 'import_wallet_bloc.dart';

@immutable
abstract class ImportWalletEvent {}

class ImportWalletRequested extends ImportWalletEvent {
  final String privateKey;

  final String network;

  ImportWalletRequested({
    required this.privateKey,
    required this.network,
  });
}
