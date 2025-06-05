// features/token/presentation/bloc/token_price_bloc.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';
import 'package:uten_wallet/features/token/domain/entity/token_entity.dart';
import 'package:uten_wallet/features/token/domain/usecase/get_token_price.dart';

import '../../../domain/usecase/get_token_prices.dart';
import '../../../domain/usecase/update_token_price.dart';

part 'token_price_event.dart';
part 'token_price_state.dart';

class TokenPriceBloc extends Bloc<TokenPriceEvent, TokenPriceState> {
  final GetTokenPrice getTokenPrice;
  final GetTokenPrices getTokenPrices;
  final UpdateTokenPrices updateTokenPrices;
  Timer? _priceUpdateTimer;

  TokenPriceBloc({
    required this.getTokenPrice,
    required this.getTokenPrices,
    required this.updateTokenPrices,
  }) : super(TokenPriceInitial()) {
    on<LoadTokenPrice>(_onLoadTokenPrice);
    on<LoadTokenPrices>(_onLoadTokenPrices);
    on<StartPriceUpdates>(_onStartPriceUpdates);
    on<StopPriceUpdates>(_onStopPriceUpdates);
    on<UpdateTokenPricesEvent>(_onUpdateTokenPrices);
  }

  Future<void> _onLoadTokenPrice(
    LoadTokenPrice event,
    Emitter<TokenPriceState> emit,
  ) async {
    emit(TokenPriceLoading());
    final result = await getTokenPrice(GetTokenPriceParams(token: event.token));

    result.fold(
      (failure) =>
          emit(TokenPriceError(message: _mapFailureToMessage(failure))),
      (price) => emit(TokenPriceLoadedSingle(token: event.token, price: price)),
    );
  }

  Future<void> _onLoadTokenPrices(
    LoadTokenPrices event,
    Emitter<TokenPriceState> emit,
  ) async {
    emit(TokenPriceLoading());
    final result = await getTokenPrices(
        GetTokenPricesParams(coinGeckoIds: event.coinGeckoIds));

    result.fold(
      (failure) =>
          emit(TokenPriceError(message: _mapFailureToMessage(failure))),
      (prices) => emit(TokenPricesLoaded(prices: prices)),
    );
  }

  Future<void> _onUpdateTokenPrices(
    UpdateTokenPricesEvent event,
    Emitter<TokenPriceState> emit,
  ) async {
    emit(TokenPriceUpdating(tokens: event.tokens));
    final result = await updateTokenPrices(
        UpdateTokenPricesParams(tokens: event.tokens as List<TokenModel>));

    result.fold(
      (failure) =>
          emit(TokenPriceError(message: _mapFailureToMessage(failure))),
      (updatedTokens) => emit(TokenPricesUpdated(tokens: updatedTokens)),
    );
  }

  void _onStartPriceUpdates(
    StartPriceUpdates event,
    Emitter<TokenPriceState> emit,
  ) {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(
      const Duration(minutes: 1), // Update every minute
      (timer) => add(UpdateTokenPricesEvent(tokens: event.tokens)),
    );
    emit(PriceUpdatesStarted());
  }

  void _onStopPriceUpdates(
    StopPriceUpdates event,
    Emitter<TokenPriceState> emit,
  ) {
    _priceUpdateTimer?.cancel();
    emit(PriceUpdatesStopped());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }

  @override
  Future<void> close() {
    _priceUpdateTimer?.cancel();
    return super.close();
  }
}
