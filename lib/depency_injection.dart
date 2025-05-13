// lib/dependency_injection.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uten_wallet/core/bloc/persist_bloc/persist_bloc.dart';
import 'package:uten_wallet/core/network/data/data_source/local_data_source/local_data_source.dart';
import 'package:uten_wallet/core/network/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:uten_wallet/core/network/data/repo_impl/network_repo_impl.dart';
import 'package:uten_wallet/core/network/domain/repository/network_repo.dart';
import 'package:uten_wallet/core/network/domain/usecase/getevmchainsusecase.dart';
import 'package:uten_wallet/core/network/presentaion/bloc/evmchain_bloc.dart';
import 'package:uten_wallet/core/network_info/network_info.dart';
import 'package:uten_wallet/features/authentication/data/data_source/auth_local_datasource.dart';
import 'package:uten_wallet/features/authentication/data/repo_impl/auth_repo_impl.dart';
import 'package:uten_wallet/features/authentication/domain/repository/auth_repo.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/delete_password_usecase.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/persist_login_usecase.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/save_password.dart';
import 'package:uten_wallet/features/authentication/domain/usecase/validate_password.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/onboarding/data/data_source/onboarding_local_data_source.dart';
import 'package:uten_wallet/features/onboarding/data/repo_impl/onboarding_repo_imp.dart';
import 'package:uten_wallet/features/onboarding/domain/repository/onboarding_repo.dart';
import 'package:uten_wallet/features/onboarding/domain/usecase/check_last_screen_usecase.dart';
import 'package:uten_wallet/features/onboarding/domain/usecase/set_last_screen_usecase.dart';
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
import 'package:uten_wallet/features/wallet/presentaion/bloc/delete_wallet/delete_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_total_balance_bloc/get_total_balance_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/mnemonic_bloc/generate_mnemonic_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/set_active_wallet/set_active_wallet_bloc.dart';

import 'package:uten_wallet/features/wallet/presentaion/bloc/update_wallet_network/update_wallet_network_bloc.dart';

import 'core/network/domain/usecase/addnewtwork.dart';
import 'core/network/domain/usecase/deletenetwork.dart';
import 'core/network/domain/usecase/getnetworkbyid.dart';
import 'core/network/domain/usecase/updatenetwork.dart';
import 'features/wallet/domain/usecase/update_wallet_network.dart';

final sl = GetIt.instance;
final internet = InternetConnectionChecker.instance;

void initDependency() {
  // Register core resources
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internet));
  sl.registerLazySingleton<http.Client>(() => http.Client());
  _evmChain();
  _initAuth();
  _wallet();
  _initOnboarding();
  _persitLgoin();
}

void _initAuth() {
  sl
    ..registerSingleton<AuthLocalDatasource>(
        AuthLocalDatasourceImpl(storage: sl<FlutterSecureStorage>()))
    ..registerSingleton<AuthRepo>(
        AuthRepoImpl(localDatasource: sl<AuthLocalDatasource>()))
    ..registerFactory<SavePasswordUsecase>(
        () => SavePasswordUsecase(authRepo: sl<AuthRepo>()))
    ..registerFactory<PersistLoginUsecase>(
        () => PersistLoginUsecase(authRepo: sl<AuthRepo>()))
    ..registerFactory<DeletePasswordUsecase>(
        () => DeletePasswordUsecase(authRepo: sl<AuthRepo>()))
    ..registerFactory(() => ValidatePasswordUsecase(authRepo: sl<AuthRepo>()))
    ..registerFactory(() => AuthBloc(
          sl<DeletePasswordUsecase>(),
          sl<PersistLoginUsecase>(),
          sl<SavePasswordUsecase>(),
          sl<ValidatePasswordUsecase>(),
        ));
}

void _wallet() {
  sl
    ..registerSingleton<WalletLocalStorage>(
        WalletLocalStorageImpl(storage: sl<FlutterSecureStorage>()))
    ..registerSingleton<WalletRepo>(WalletRepoImpl(
        localStorage: sl<WalletLocalStorage>(),
        evmChainLocalDataSource: sl<EvmChainLocalDataSource>()))
    ..registerFactory(() => GenerateMnemonic(sl<WalletRepo>()))
    ..registerFactory(() => DeleteWallet(sl<WalletRepo>()))
    ..registerFactory(() => GenerateWallet(sl<WalletRepo>()))
    ..registerFactory(() => GetActiveWallet(sl<WalletRepo>()))
    ..registerFactory(() => GetAllWallets(sl<WalletRepo>()))
    ..registerFactory(() => GetTotalBalance(sl<WalletRepo>()))
    ..registerFactory(() => UpdateWalletNetwork(sl<WalletRepo>()))
    ..registerFactory(() => ImportWallet(sl<WalletRepo>()))
    ..registerFactory(() => SetActiveWallet(sl<WalletRepo>()))
    ..registerFactory(() => UpdateWallet(sl<WalletRepo>()))
    ..registerFactory(() => GenerateMnemonicBloc(sl<GenerateMnemonic>()))
    ..registerFactory(() => GetTotalBalanceBloc(sl<GetTotalBalance>()))
    ..registerFactory(() => ImportWalletBloc(sl<ImportWallet>()))
    ..registerFactory(() => GenerateWalletBloc(sl<GenerateWallet>()))
    ..registerFactory(
        () => GetActiveWalletBloc(getActiveWallet: sl<GetActiveWallet>()))
    ..registerFactory(() => WalletBloc(sl<GetAllWallets>()))
    ..registerFactory(() => WalletNetworkBloc(sl<UpdateWalletNetwork>()))
    ..registerFactory(() => DeleteWalletBloc(sl<DeleteWallet>()))
    ..registerFactory(() =>
        SetMyActiveWalletBloc(setActiveWalletUseCase: sl<SetActiveWallet>()));
}

void _initOnboarding() {
  sl
    ..registerSingleton<OnboardingLocalDataSource>(
        OnboardingLocalDataSourceImpl(storage: sl<FlutterSecureStorage>()))
    ..registerSingleton<OnboardingRepository>(OnboardingRepositoryImpl(
        localDataSource: sl<OnboardingLocalDataSource>()))
    ..registerFactory(() => SetLastScreenUseCase(sl<OnboardingRepository>()))
    ..registerFactory(() => CheckLastScreenUseCase(sl<OnboardingRepository>()))
    ..registerFactory(() => OnboardingBloc(
        checkLastScreenUseCase: sl<CheckLastScreenUseCase>(),
        setLastScreenUseCase: sl<SetLastScreenUseCase>()));
}

void _persitLgoin() {
  sl.registerFactory(() => PersistBloc(sl<FlutterSecureStorage>()));
}

void _evmChain() {
  // Register the remote data source for EVM Chains
  sl.registerLazySingleton<EvmChainRemoteDataSource>(
    () => EvmChainRemoteDataSourceImpl(
      client: sl<http.Client>(),
      apiUrl: 'https://chainid.network/chains.json',
    ),
  );

  // Register the local data source
  sl.registerLazySingleton<EvmChainLocalDataSource>(
    () => EvmChainLocalDataSourceImpl(storage: sl<FlutterSecureStorage>()),
  );

  // Register the repository
  sl.registerLazySingleton<EvmChainRepository>(
    () => EvmChainRepositoryImpl(
      remoteDataSource: sl<EvmChainRemoteDataSource>(),
      localDataSource: sl<EvmChainLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Register use cases
  sl.registerFactory<GetEvmChains>(
      () => GetEvmChains(sl<EvmChainRepository>()));
  sl.registerFactory<AddNetwork>(() => AddNetwork(sl<EvmChainRepository>()));
  sl.registerFactory<UpdateNetwork>(
      () => UpdateNetwork(sl<EvmChainRepository>()));
  sl.registerFactory<DeleteNetwork>(
      () => DeleteNetwork(sl<EvmChainRepository>()));
  sl.registerFactory<GetNetworkById>(
      () => GetNetworkById(sl<EvmChainRepository>()));

  // Register the BLoC
  sl.registerFactory<EvmChainBloc>(
    () => EvmChainBloc(
      sl<GetEvmChains>(),
      addNetwork: sl<AddNetwork>(),
      updateNetwork: sl<UpdateNetwork>(),
      deleteNetwork: sl<DeleteNetwork>(),
    ),
  );
}
