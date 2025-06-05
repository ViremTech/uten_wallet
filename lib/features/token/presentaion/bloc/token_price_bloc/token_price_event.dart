// features/token/presentation/bloc/token_price_event.dart
part of 'token_price_bloc.dart';

abstract class TokenPriceEvent extends Equatable {
  const TokenPriceEvent();

  @override
  List<Object> get props => [];
}

class LoadTokenPrice extends TokenPriceEvent {
  final TokenEntity token;

  const LoadTokenPrice(this.token);

  @override
  List<Object> get props => [token];
}

class LoadTokenPrices extends TokenPriceEvent {
  final List<String> coinGeckoIds;

  const LoadTokenPrices(this.coinGeckoIds);

  @override
  List<Object> get props => [coinGeckoIds];
}

class UpdateTokenPricesEvent extends TokenPriceEvent {
  final List<TokenEntity> tokens;

  const UpdateTokenPricesEvent({required this.tokens});

  @override
  List<Object> get props => [tokens];
}

class StartPriceUpdates extends TokenPriceEvent {
  final List<TokenEntity> tokens;

  const StartPriceUpdates(this.tokens);

  @override
  List<Object> get props => [tokens];
}

class StopPriceUpdates extends TokenPriceEvent {
  const StopPriceUpdates();
}
