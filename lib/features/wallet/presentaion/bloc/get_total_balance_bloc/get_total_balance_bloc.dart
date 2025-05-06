import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecase/get_total_balance.dart';

part 'get_total_balance_event.dart';
part 'get_total_balance_state.dart';

class GetTotalBalanceBloc
    extends Bloc<GetTotalBalanceEvent, GetTotalBalanceState> {
  final GetTotalBalance getTotalBalance;

  GetTotalBalanceBloc(this.getTotalBalance) : super(GetTotalBalanceInitial()) {
    on<GetTotalBalanceRequested>((event, emit) async {
      emit(GetTotalBalanceLoading());
      final result = await getTotalBalance(NoParams());
      result.fold(
        (failure) => emit(GetTotalBalanceFailure(failure.message)),
        (balance) => emit(GetTotalBalanceSuccess(balance)),
      );
    });
  }
}
