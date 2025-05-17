// features/token/presentation/bloc/token_state.dart
part of 'token_bloc.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object> get props => [];
}

class TokenInitial extends TokenState {}

class TokenLoading extends TokenState {}

class TokenOperationInProgress extends TokenState {}

class TokenLoaded extends TokenState {
  final List<TokenEntity> tokens;

  const TokenLoaded(this.tokens);

  @override
  List<Object> get props => [tokens];
}

class TokenError extends TokenState {
  final String message;

  const TokenError(this.message);

  @override
  List<Object> get props => [message];
}

class TokenAddedSuccessfully extends TokenState {}

class TokenRemovedSuccessfully extends TokenState {}
