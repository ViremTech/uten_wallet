// import 'package:dartz/dartz.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/error/failure.dart';
// import '../../../domain/entity/token_entity.dart';
// import '../../../domain/usecase/get_token_price.dart';

// part 'token_price_event.dart';
// part 'token_price_state.dart';

// class TokenPriceBloc extends Bloc<TokenPriceEvent, TokenPriceState> {
//   final GetTokenPrice getTokenPrice;

//   TokenPriceBloc({required this.getTokenPrice}) : super(TokenPriceInitial()) {
//     on<FetchTokenPrice>((event, emit) async {
//       emit(TokenPriceLoading());
//       final failureOrToken = await getTokenPrice(event.token);
//       emit(_mapFailureOrTokenToState(failureOrToken));
//     });
//   }

//   TokenPriceState _mapFailureOrTokenToState(
//     Either<Failure, TokenEntity> failureOrToken,
//   ) {
//     return failureOrToken.fold(
//       (failure) => TokenPriceError(message: _mapFailureToMessage(failure)),
//       (token) => TokenPriceLoaded(token: token),
//     );
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return 'Server error: ${failure.message}';
//       case CacheFailure:
//         return 'Cache error: ${failure.message}';
//       default:
//         return 'Unexpected error';
//     }
//   }
// }
