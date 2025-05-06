part of 'generate_mnemonic_bloc.dart';

@immutable
abstract class GenerateMnemonicState {}

class GenerateMnemonicInitial extends GenerateMnemonicState {}

class GenerateMnemonicLoading extends GenerateMnemonicState {}

class GenerateMnemonicSuccess extends GenerateMnemonicState {
  final String mnemonic;
  GenerateMnemonicSuccess(this.mnemonic);
}

class GenerateMnemonicFailure extends GenerateMnemonicState {
  final String message;
  GenerateMnemonicFailure(this.message);
}
