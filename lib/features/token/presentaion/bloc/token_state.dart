part of 'token_bloc.dart';

sealed class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

final class TokenInitial extends TokenState {}

final class TokenLoading extends TokenState {}

final class TokenLoaded extends TokenState {
  final List<TokenEntity> tokens;
  const TokenLoaded(this.tokens);

  @override
  List<Object> get props => [tokens];
}

final class TokenError extends TokenState {
  final String message;
  const TokenError(this.message);

  @override
  List<Object> get props => [message];
}

final class TokenNetworkMismatch extends TokenState {
  final String message;
  const TokenNetworkMismatch(this.message);

  @override
  List<Object> get props => [message];
}

final class TokenOperationInProgress extends TokenState {}

final class TokenAddedSuccessfully extends TokenState {}

final class TokenRemovedSuccessfully extends TokenState {}
