part of 'persist_bloc.dart';

@immutable
sealed class PersistEvent {}

class CheckSeedPhraseStatus extends PersistEvent {}
