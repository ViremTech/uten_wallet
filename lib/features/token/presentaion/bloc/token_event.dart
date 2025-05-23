part of 'token_bloc.dart';

sealed class TokenEvent extends Equatable {
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

class VerifyAndAddToken extends TokenEvent {
  final String walletId;
  final TokenModel token;
  final int currentChainId;
  const VerifyAndAddToken({
    required this.walletId,
    required this.token,
    required this.currentChainId,
  });

  @override
  List<Object> get props => [walletId, token, currentChainId];
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
  final int chainId;
  const RemoveToken({
    required this.walletId,
    required this.tokenContractAddress,
    required this.chainId,
  });

  @override
  List<Object> get props => [walletId, tokenContractAddress, chainId];
}
