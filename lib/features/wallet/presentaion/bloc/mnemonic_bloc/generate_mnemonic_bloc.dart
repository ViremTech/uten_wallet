import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/generate_mnemonic.dart';

part 'generate_mnemonic_event.dart';
part 'generate_mnemonic_state.dart';

class GenerateMnemonicBloc
    extends Bloc<GenerateMnemonicEvent, GenerateMnemonicState> {
  final GenerateMnemonic generateMnemonic;

  GenerateMnemonicBloc(this.generateMnemonic)
      : super(GenerateMnemonicInitial()) {
    on<GenerateMnemonicRequested>((event, emit) async {
      emit(GenerateMnemonicLoading());
      final result = await generateMnemonic(NoParams());
      result.fold(
        (failure) => emit(GenerateMnemonicFailure(failure.message)),
        (mnemonic) => emit(GenerateMnemonicSuccess(mnemonic)),
      );
    });
  }
}
