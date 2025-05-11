import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../error/failure.dart';
import '../../../usecase/usecase.dart';
import '../../domain/entity/network_entity.dart';
import '../../domain/usecase/addnewtwork.dart';
import '../../domain/usecase/deletenetwork.dart';
import '../../domain/usecase/getevmchainsusecase.dart';
import '../../domain/usecase/updatenetwork.dart';

part 'evmchain_event.dart';
part 'evmchain_state.dart';

class EvmChainBloc extends Bloc<EvmChainEvent, EvmChainState> {
  final GetEvmChains getEvmChains;
  final AddNetwork? addNetwork;
  final UpdateNetwork? updateNetwork;
  final DeleteNetwork? deleteNetwork;

  EvmChainBloc(
    this.getEvmChains, {
    this.addNetwork,
    this.updateNetwork,
    this.deleteNetwork,
  }) : super(EvmChainInitialState()) {
    on<LoadEvmChainsEvent>(_onLoadEvmChains);
    on<AddNetworkEvent>(_onAddNetwork);
    on<UpdateNetworkEvent>(_onUpdateNetwork);
    on<DeleteNetworkEvent>(_onDeleteNetwork);
  }

  Future<void> _onLoadEvmChains(
    LoadEvmChainsEvent event,
    Emitter<EvmChainState> emit,
  ) async {
    emit(EvmChainLoadingState());
    final result = await getEvmChains(NoParams());

    result.fold(
      (failure) => emit(EvmChainErrorState(_mapFailureToMessage(failure))),
      (chains) => emit(EvmChainLoadedState(chains)),
    );
  }

  Future<void> _onAddNetwork(
    AddNetworkEvent event,
    Emitter<EvmChainState> emit,
  ) async {
    if (addNetwork == null) {
      emit(const EvmChainErrorState('Add network functionality not available'));
      return;
    }

    emit(EvmChainLoadingState());
    final result = await addNetwork!(event.network);

    result.fold(
      (failure) => emit(EvmChainErrorState(_mapFailureToMessage(failure))),
      (success) {
        if (success) {
          // Reload networks to reflect the changes
          add(LoadEvmChainsEvent());
          emit(
              const NetworkOperationSuccessState('Network added successfully'));
        } else {
          emit(const EvmChainErrorState('Failed to add network'));
        }
      },
    );
  }

  Future<void> _onUpdateNetwork(
    UpdateNetworkEvent event,
    Emitter<EvmChainState> emit,
  ) async {
    if (updateNetwork == null) {
      emit(const EvmChainErrorState(
          'Update network functionality not available'));
      return;
    }

    emit(EvmChainLoadingState());
    final result = await updateNetwork!(event.network);

    result.fold(
      (failure) => emit(EvmChainErrorState(_mapFailureToMessage(failure))),
      (success) {
        if (success) {
          // Reload networks to reflect the changes
          add(LoadEvmChainsEvent());
          emit(const NetworkOperationSuccessState(
              'Network updated successfully'));
        } else {
          emit(const EvmChainErrorState(
              'Failed to update network. Only custom networks can be updated.'));
        }
      },
    );
  }

  Future<void> _onDeleteNetwork(
    DeleteNetworkEvent event,
    Emitter<EvmChainState> emit,
  ) async {
    if (deleteNetwork == null) {
      emit(const EvmChainErrorState(
          'Delete network functionality not available'));
      return;
    }

    emit(EvmChainLoadingState());
    final result = await deleteNetwork!(event.networkId);

    result.fold(
      (failure) => emit(EvmChainErrorState(_mapFailureToMessage(failure))),
      (success) {
        if (success) {
          // Reload networks to reflect the changes
          add(LoadEvmChainsEvent());
          emit(const NetworkOperationSuccessState(
              'Network deleted successfully'));
        } else {
          emit(const EvmChainErrorState(
              'Failed to delete network. Only custom networks can be deleted.'));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
