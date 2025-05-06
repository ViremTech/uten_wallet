part of 'import_wallet_bloc.dart';

@immutable
abstract class ImportWalletEvent {}

class ImportWalletRequested extends ImportWalletEvent {
  final String privateKey;
  final String name;
  final String network;

  ImportWalletRequested({
    required this.privateKey,
    required this.name,
    required this.network,
  });
}
