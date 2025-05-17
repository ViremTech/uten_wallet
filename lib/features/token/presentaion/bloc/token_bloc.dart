// features/token/presentation/bloc/token_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/error/failure.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';

import '../../domain/entity/token_entity.dart';
import '../../domain/usecase/add_token_to_wallet.dart';
import '../../domain/usecase/get_cache_tokens.dart';
import '../../domain/usecase/get_toke_usecase.dart';
import '../../domain/usecase/get_wallet_token.dart';

import '../../domain/usecase/remove_token_from_wallet.dart';

part 'token_event.dart';
part 'token_state.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  final GetTokens getTokens;
  final GetCachedTokens getCachedTokens;
  final AddTokenToWallet addTokenToWallet;
  final GetWalletTokens getWalletTokens;
  final RemoveTokenFromWallet removeTokenFromWallet;

  TokenBloc({
    required this.getTokens,
    required this.getCachedTokens,
    required this.addTokenToWallet,
    required this.getWalletTokens,
    required this.removeTokenFromWallet,
  }) : super(TokenInitial()) {
    on<FetchTokens>(_onFetchTokens);
    on<LoadCachedTokens>(_onLoadCachedTokens);
    on<AddToken>(_onAddToken);
    on<LoadWalletTokens>(_onLoadWalletTokens);
    on<RemoveToken>(_onRemoveToken);
  }

  Future<void> _onFetchTokens(
      FetchTokens event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    final result = await getTokens(event.chainId);
    _emitTokenState(result, emit);
  }

  Future<void> _onLoadCachedTokens(
      LoadCachedTokens event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    final result = await getCachedTokens(event.chainId);
    _emitTokenState(result, emit);
  }

  Future<void> _onLoadWalletTokens(
      LoadWalletTokens event, Emitter<TokenState> emit) async {
    emit(TokenLoading());
    final result =
        await getWalletTokens(Params(event.walletId, chainId: event.chainId));
    _emitTokenState(result, emit);
  }

  void _emitTokenState(
    Either<Failure, List<TokenEntity>> result,
    Emitter<TokenState> emit,
  ) {
    result.fold(
      (failure) => emit(TokenError(failure.message)),
      (tokens) => emit(TokenLoaded(tokens)),
    );
  }

  Future<void> _onAddToken(AddToken event, Emitter<TokenState> emit) async {
    emit(TokenOperationInProgress());
    final result = await addTokenToWallet(
      AddTokenParams(walletId: event.walletId, token: event.token),
    );

    result.fold(
      (failure) => emit(TokenError(failure.message)),
      (_) {
        emit(TokenAddedSuccessfully());
        // Reload wallet tokens after adding
        add(LoadWalletTokens(
            walletId: event.walletId, chainId: event.token.chainId));
      },
    );
  }

  Future<void> _onRemoveToken(
      RemoveToken event, Emitter<TokenState> emit) async {
    emit(TokenOperationInProgress());
    final result = await removeTokenFromWallet(
      RemoveTokenParams(
        walletId: event.walletId,
        tokenContractAddress: event.tokenContractAddress,
      ),
    );

    result.fold(
      (failure) => emit(TokenError(failure.message)),
      (_) {
        emit(TokenRemovedSuccessfully());
        // Reload wallet tokens after removing
        add(LoadWalletTokens(walletId: event.walletId, chainId: event.chainId));
      },
    );
  }
}
