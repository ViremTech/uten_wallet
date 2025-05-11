import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/widget/password_field.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallet_home.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? _passwordError;
  bool _obscureText = true;

  void _validatePassword() {
    final password = _passwordController.text;

    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  bool get _isFormValid =>
      _passwordController.text.isNotEmpty && _passwordError == null;
  @override
  void initState() {
    _passwordController.addListener(_validatePassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Image.asset(
                'assets/images/login.png',
                height: 480,
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Welcome back to \nUten Wallet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                        color: Colors.white,
                        fontSize: 24,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is Authenticated) {
                        context.read<GetActiveWalletBloc>().add(
                              LoadActiveWallet(),
                            );
                      }
                    },
                  ),
                  BlocListener<GetActiveWalletBloc, ActiveWalletState>(
                    listener: (context, state) {
                      if (state is ActiveWalletLoaded) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletHome(
                              wallet: state.wallet! as WalletModel,
                            ),
                          ),
                        );
                      }
                      if (state is ActiveWalletError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                  ),
                ],
                child: PasswordField(
                  onPressed: () {
                    setState(
                      () {
                        _obscureText = !_obscureText;
                      },
                    );
                  },
                  controller: _passwordController,
                  validator: (_) => _passwordError,
                  obscureText: _obscureText,
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 36),
              ButtonWidget(
                  paddng: 16,
                  onPressed: _isFormValid
                      ? () {
                          context.read<AuthBloc>().add(
                                ValidatePasswordEvent(
                                    password: _passwordController.text),
                              );
                        }
                      : null,
                  color: _isFormValid ? Colors.white : Colors.grey,
                  text: 'Login',
                  textColor: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
