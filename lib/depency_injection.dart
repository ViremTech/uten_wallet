import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:uten_wallet/features/authentication/data/data_source/auth_local_datasource.dart';
import 'package:uten_wallet/features/authentication/data/repo_impl/auth_repo_impl.dart';
import 'package:uten_wallet/features/authentication/domain/repository/auth_repo.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/delete_password_usecase.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/persist_login_usecase.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/save_password.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/validate_password.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/onboarding/presentaion/bloc/onboarding_bloc.dart';
import 'package:uten_wallet/features/wallet/data/data_source/wallet_local_storage.dart';
import 'package:uten_wallet/features/wallet/data/repo_impl/wallet_repo_impl.dart';
import 'package:uten_wallet/features/wallet/domain/repository/wallet_repo.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/delete_wallet.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/generate_mnemonic.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/generate_wallet.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/get_active_wallet.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/get_all_wallets.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/get_total_balance.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/import_wallet.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/set_active_wallet.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/update_wallet.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_total_balance_bloc/get_total_balance_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/mnemonic_bloc/generate_mnemonic_bloc.dart';

import 'features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'features/onboarding/data/repo_impl/onboarding_repo_imp.dart';
import 'features/onboarding/domain/repository/onboarding_repo.dart';
import 'features/onboarding/domain/usecase/check_last_screen_usecase.dart';
import 'features/onboarding/domain/usecase/set_last_screen_usecase.dart';

final sl = GetIt.instance;

void initDependency() {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  _initAuth();
  _wallet();
  _initOnboarding();
}

void _initAuth() {
  // Local storage and dependencies
  sl
    ..registerSingleton<AuthLocalDatasource>(
      AuthLocalDatasourceImpl(
        storage: sl<FlutterSecureStorage>(),
      ),
    )
    ..registerSingleton<AuthRepo>(
      AuthRepoImpl(
        localDatasource: sl<AuthLocalDatasource>(),
      ),
    )
    ..registerFactory<SavePasswordUsecase>(
      () => SavePasswordUsecase(
        authRepo: sl<AuthRepo>(),
      ),
    )
    ..registerFactory<PersistLoginUsecase>(() => PersistLoginUsecase(
          authRepo: sl<AuthRepo>(),
        ))
    ..registerFactory<DeletePasswordUsecase>(
      () => DeletePasswordUsecase(
        authRepo: sl<AuthRepo>(),
      ),
    )
    ..registerFactory(
      () => ValidatePasswordUsecase(
        authRepo: sl<AuthRepo>(),
      ),
    )
    ..registerFactory(
      () => AuthBloc(
        sl<DeletePasswordUsecase>(),
        sl<PersistLoginUsecase>(),
        sl<SavePasswordUsecase>(),
        sl<ValidatePasswordUsecase>(),
      ),
    );
}

void _wallet() {
  sl
    ..registerSingleton<WalletLocalStorage>(
      WalletLocalStorageImpl(
        storage: sl<FlutterSecureStorage>(),
      ),
    )
    ..registerSingleton<WalletRepo>(
      WalletRepoImpl(
        localStorage: sl<WalletLocalStorage>(),
      ),
    )
    ..registerFactory(() => GenerateMnemonic(sl<WalletRepo>()))
    ..registerFactory(() => DeleteWallet(sl<WalletRepo>()))
    ..registerFactory(() => GenerateWallet(sl<WalletRepo>()))
    ..registerFactory(() => GetActiveWallet(sl<WalletRepo>()))
    ..registerFactory(() => GetAllWallets(sl<WalletRepo>()))
    ..registerFactory(() => GetTotalBalance(sl<WalletRepo>()))
    ..registerFactory(() => ImportWallet(sl<WalletRepo>()))
    ..registerFactory(() => SetActiveWallet(sl<WalletRepo>()))
    ..registerFactory(() => UpdateWallet(sl<WalletRepo>()))
    ..registerFactory(() => GenerateMnemonicBloc(sl<GenerateMnemonic>()))
    ..registerFactory(() => GetTotalBalanceBloc(sl<GetTotalBalance>()))
    ..registerFactory(() => ImportWalletBloc(sl<ImportWallet>()))
    ..registerFactory(() => GenerateWalletBloc(sl<GenerateWallet>()))
    ..registerFactory(
        () => GetActiveWalletBloc(getActiveWallet: sl<GetActiveWallet>()));
}

void _initOnboarding() {
  sl
    ..registerSingleton<OnboardingLocalDataSource>(
      OnboardingLocalDataSourceImpl(storage: sl<FlutterSecureStorage>()),
    )
    ..registerSingleton<OnboardingRepository>(
      OnboardingRepositoryImpl(
          localDataSource: sl<OnboardingLocalDataSource>()),
    )
    ..registerFactory(() => SetLastScreenUseCase(sl<OnboardingRepository>()))
    ..registerFactory(() => CheckLastScreenUseCase(sl<OnboardingRepository>()))
    ..registerFactory(
      () => OnboardingBloc(
        checkLastScreenUseCase: sl<CheckLastScreenUseCase>(),
        setLastScreenUseCase: sl<SetLastScreenUseCase>(),
      ),
    );
}
