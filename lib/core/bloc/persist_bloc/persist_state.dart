part of 'persist_bloc.dart';

@immutable
sealed class PersistState {}

class WalletInitInitial extends PersistState {}

class WalletInitLoading extends PersistState {}

class WalletNeedsSetup extends PersistState {}

class WalletReady extends PersistState {}
