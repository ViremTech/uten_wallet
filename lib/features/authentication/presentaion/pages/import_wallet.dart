import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallet_home.dart';
import '../../../onboarding/presentaion/widget/button_widget.dart';
import '../widget/seed_phrase_field.dart';
import '../widget/password_field.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  final _formKey = GlobalKey<FormState>();
  final _seedController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String privateKey;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _passwordError;
  String? _confirmPasswordError;
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _passwordsMatch = false;
  bool _agreedToTerms = false;

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);

      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (!_hasMinLength) {
        _passwordError = 'Must be at least 8 characters';
      } else if (!_hasUppercase) {
        _passwordError = 'Must contain an uppercase letter';
      } else if (!_hasNumber) {
        _passwordError = 'Must contain a number';
      } else {
        _passwordError = null;
      }

      _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
        _passwordsMatch = false;
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Passwords do not match';
        _passwordsMatch = false;
      } else {
        _confirmPasswordError = null;
        _passwordsMatch = true;
      }
    });
  }

  String generatePrivate(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final path = "m/44'/60'/0'/0/0";
    final childKey = root.derivePath(path);
    final privateKey = childKey.privateKey;
    final hexPrivateKey = hex.encode(privateKey!);
    return hexPrivateKey;
  }

  @override
  void initState() {
    privateKey = generatePrivate(_seedController.text);
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _seedController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _passwordError == null &&
      _confirmPasswordError == null &&
      _passwordsMatch &&
      _seedController.text.isNotEmpty &&
      _agreedToTerms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Wallet'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImportSeedPhraseField(controller: _seedController),
                    const SizedBox(height: 20),
                    const Text("Password"),
                    const SizedBox(height: 8),
                    PasswordField(
                      controller: _passwordController,
                      validator: (_) => _passwordError,
                      hintText: "Enter password",
                      obscureText: _obscurePassword,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    PasswordRequirementsList(
                      hasMinLength: _hasMinLength,
                      hasUppercase: _hasUppercase,
                      hasNumber: _hasNumber,
                    ),
                    const SizedBox(height: 20),
                    const Text("Confirm Password"),
                    const SizedBox(height: 8),
                    PasswordField(
                      controller: _confirmPasswordController,
                      validator: (_) => _confirmPasswordError,
                      hintText: "Re-enter password",
                      obscureText: _obscureConfirmPassword,
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    AnimatedOpacity(
                      opacity: (_confirmPasswordController.text.isNotEmpty &&
                              _passwordsMatch)
                          ? 1.0
                          : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Text('Passwords match',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) {
                            setState(() {
                              _agreedToTerms = val ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToTerms = !_agreedToTerms;
                              });
                            },
                            child: const Text(
                              'I agree to the Terms and Conditions and Privacy Policy',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: MultiBlocListener(
                listeners: [
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        context.read<ImportWalletBloc>().add(
                              ImportWalletRequested(
                                name: 'Wallet 1',
                                privateKey: privateKey,
                                network: 'ethereum',
                              ),
                            );
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.message,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  BlocListener<ImportWalletBloc, ImportWalletState>(
                    listener: (context, state) {
                      if (state is ImportWalletSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Wallet imported successfully!',
                            ),
                          ),
                        );

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WalletHome(
                                      wallet: state.wallet,
                                    ),
                                settings: RouteSettings(name: '/wallet_home')),
                            (route) => false);
                      }
                      if (state is ImportWalletFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.message,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
                child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ButtonWidget(
                    paddng: 16,
                    onPressed: _isFormValid
                        ? () {
                            context.read<AuthBloc>().add(
                                  SavePasswordEvent(
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        : null,
                    color: _isFormValid && _agreedToTerms
                        ? Colors.white
                        : Colors.grey[900],
                    text: 'Next',
                    textColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordRequirementsList extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;

  const PasswordRequirementsList({
    super.key,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumber,
  });

  Widget _buildItem(String label, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.cancel_outlined,
          color: met ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: met ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItem("At least 8 characters", hasMinLength),
        _buildItem("At least one uppercase letter", hasUppercase),
        _buildItem("At least one number", hasNumber),
      ],
    );
  }
}
