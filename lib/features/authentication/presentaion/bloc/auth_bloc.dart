import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uten_wallet/core/usecase/usecase.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/delete_password_usecase.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';

import '../../domain/usecase/persist_login_usecase.dart';
import '../../domain/usecase/save_password.dart';
import '../../domain/usecase/validate_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DeletePasswordUsecase deletePassword;
  final PersistLoginUsecase persistLoginUsecase;
  final SavePasswordUsecase savePassword;
  final ValidatePasswordUsecase validatePassword;

  AuthBloc(
    this.deletePassword,
    this.persistLoginUsecase,
    this.savePassword,
    this.validatePassword,
  ) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<SavePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final res = await savePassword(event.password);

      res.fold((failure) => emit(AuthError(message: failure.message)),
          (password) => emit(AuthSuccess()));
    });
    on<ValidatePasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final res = await validatePassword(event.password);

      res.fold(
        (failure) {
          emit(AuthError(message: failure.message));
        },
        (success) => emit(
          Authenticated(
            isAuthenticated: success,
          ),
        ),
      );
    });
    on<DeletePasswordEvent>(
      (event, emit) async {
        emit(AuthLoading());
        final res = await deletePassword(NoParams());
        res.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (success) => emit(
            PassDeleted(deleted: success),
          ),
        );
      },
    );
    on<PersistLoginStateEvent>((event, emit) async {
      emit(AuthLoading());
      final res = await persistLoginUsecase(Param(value: event.status));
      res.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (success) => emit(Persisted(isPersisted: success)),
      );
    });
  }
}
