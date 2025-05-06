import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/theme/dart_theme.dart';
import 'package:uten_wallet/depency_injection.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/import_wallet.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_total_balance_bloc/get_total_balance_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/mnemonic_bloc/generate_mnemonic_bloc.dart';
import 'package:uten_wallet/init_page.dart';

import 'features/onboarding/presentaion/bloc/onboarding_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependency();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => sl<OnboardingBloc>()..add(CheckIfSeenOnboarding()),
      ),
      BlocProvider(
        create: (context) => sl<AuthBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<GenerateMnemonicBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<GenerateWalletBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<ImportWalletBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<GetTotalBalanceBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<GetActiveWalletBloc>(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: InitPage(),
    );
  }
}
