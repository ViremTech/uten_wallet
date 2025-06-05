part of 'token_price_bloc.dart';

abstract class TokenPriceState extends Equatable {
  const TokenPriceState();

  @override
  List<Object> get props => [];
}

class TokenPriceInitial extends TokenPriceState {}

class TokenPriceLoading extends TokenPriceState {}

class TokenPriceUpdating extends TokenPriceState {
  final List<TokenEntity> tokens;

  const TokenPriceUpdating({required this.tokens});

  @override
  List<Object> get props => [tokens];
}

class TokenPriceLoadedSingle extends TokenPriceState {
  final TokenEntity token;
  final TokenPrice price;

  const TokenPriceLoadedSingle({required this.token, required this.price});

  @override
  List<Object> get props => [token, price];
}

class TokenPricesLoaded extends TokenPriceState {
  final Map<String, TokenPrice> prices;

  const TokenPricesLoaded({required this.prices});

  @override
  List<Object> get props => [prices];
}

class TokenPricesUpdated extends TokenPriceState {
  final List<TokenEntity> tokens;

  const TokenPricesUpdated({required this.tokens});

  @override
  List<Object> get props => [tokens];
}

class PriceUpdatesStarted extends TokenPriceState {}

class PriceUpdatesStopped extends TokenPriceState {}

class TokenPriceError extends TokenPriceState {
  final String message;

  const TokenPriceError({required this.message});

  @override
  List<Object> get props => [message];
}
