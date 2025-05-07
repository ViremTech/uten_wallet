part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final bool isAuthenticated;

  Authenticated({
    required this.isAuthenticated,
  });
}

class AuthSuccess extends AuthState {}

class PassDeleted extends AuthState {
  final bool deleted;

  PassDeleted({required this.deleted});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class Persisted extends AuthState {
  final bool isPersisted;

  Persisted({required this.isPersisted});
}
