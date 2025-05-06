part of 'get_total_balance_bloc.dart';

@immutable
abstract class GetTotalBalanceState {}

class GetTotalBalanceInitial extends GetTotalBalanceState {}

class GetTotalBalanceLoading extends GetTotalBalanceState {}

class GetTotalBalanceSuccess extends GetTotalBalanceState {
  final double balance;
  GetTotalBalanceSuccess(this.balance);
}

class GetTotalBalanceFailure extends GetTotalBalanceState {
  final String message;
  GetTotalBalanceFailure(this.message);
}
