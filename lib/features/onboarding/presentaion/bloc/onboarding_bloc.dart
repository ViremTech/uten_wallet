import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecase/check_last_screen_usecase.dart';
import '../../domain/usecase/set_last_screen_usecase.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckLastScreenUseCase checkLastScreenUseCase;
  final SetLastScreenUseCase setLastScreenUseCase;

  OnboardingBloc({
    required this.checkLastScreenUseCase,
    required this.setLastScreenUseCase,
  }) : super(OnboardingInitial()) {
    on<CheckIfSeenOnboarding>((event, emit) async {
      emit(OnboardingLoading());
      final result = await checkLastScreenUseCase(NoParams());

      result.fold(
        (failure) => emit(OnboardingFailure(failure.message)),
        (seen) => emit(seen ? OnboardingSeen() : OnboardingNotSeen()),
      );
    });

    on<CompleteOnboarding>((event, emit) async {
      emit(OnboardingLoading());
      final result = await setLastScreenUseCase(NoParams());

      result.fold(
        (failure) => emit(OnboardingFailure(failure.message)),
        (_) => emit(OnboardingCompleted()),
      );
    });
  }
}
