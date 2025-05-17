// features/token/presentation/bloc/token_event.dart
part of 'token_bloc.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object> get props => [];
}

class FetchTokens extends TokenEvent {
  final int chainId;

  const FetchTokens(this.chainId);

  @override
  List<Object> get props => [chainId];
}

class LoadCachedTokens extends TokenEvent {
  final int chainId;

  const LoadCachedTokens(this.chainId);

  @override
  List<Object> get props => [chainId];
}

class AddToken extends TokenEvent {
  final String walletId;
  final TokenModel token;

  const AddToken({required this.walletId, required this.token});

  @override
  List<Object> get props => [walletId, token];
}

class LoadWalletTokens extends TokenEvent {
  final String walletId;
  final int? chainId;

  const LoadWalletTokens({required this.walletId, this.chainId});

  @override
  List<Object> get props => [walletId, chainId ?? 0];
}

class RemoveToken extends TokenEvent {
  final String walletId;
  final String tokenContractAddress;
  final int? chainId;

  const RemoveToken({
    required this.walletId,
    required this.tokenContractAddress,
    this.chainId,
  });

  @override
  List<Object> get props => [walletId, tokenContractAddress, chainId ?? 0];
}
