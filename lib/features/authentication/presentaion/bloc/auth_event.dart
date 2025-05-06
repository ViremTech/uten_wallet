part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SavePasswordEvent extends AuthEvent {
  final String password;

  SavePasswordEvent({required this.password});
}

class ValidatePasswordEvent extends AuthEvent {
  final String password;

  ValidatePasswordEvent({required this.password});
}

class DeletePasswordEvent extends AuthEvent {}
