// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// import '../../../../domain/entity/wallet_entity.dart';
// import '../../../../domain/usecase/update_wallet_price_usecase.dart';

// part 'update_wallet_token_price_event.dart';
// part 'update_wallet_token_price_state.dart';

// class UpdateWalletTokenPriceBloc
//     extends Bloc<UpdateWalletTokenPriceEvent, UpdateWalletTokenPriceState> {
//   final UpdateWalletPriceUsecase usecase;

//   UpdateWalletTokenPriceBloc(this.usecase)
//       : super(UpdateWalletTokenPriceInitial()) {
//     on<StartUpdateWalletTokenPrice>(_onUpdateWalletPrice);
//   }

//   Future<void> _onUpdateWalletPrice(
//     StartUpdateWalletTokenPrice event,
//     Emitter<UpdateWalletTokenPriceState> emit,
//   ) async {
//     emit(UpdateWalletTokenPriceLoading());

//     final result = await usecase(UpdateWalletPriceParams(
//       wallet: event.wallet,
//       chainId: event.chainId,
//     ));

//     result.fold(
//       (failure) => emit(UpdateWalletTokenPriceFailure(failure.message)),
//       (wallet) => emit(UpdateWalletTokenPriceSuccess(wallet)),
//     );
//   }
// }
