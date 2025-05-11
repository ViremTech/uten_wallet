import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallet_home.dart';
import '../../../authentication/presentaion/widget/seed_phrase_field.dart';
import '../../../onboarding/presentaion/widget/button_widget.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

import '../widget/import_private_key_field.dart';

class CreateWalletWithPrivateKey extends StatefulWidget {
  const CreateWalletWithPrivateKey({super.key});

  @override
  State<CreateWalletWithPrivateKey> createState() =>
      _CreateWalletWithPrivateKeyState();
}

class _CreateWalletWithPrivateKeyState
    extends State<CreateWalletWithPrivateKey> {
  final _formKey = GlobalKey<FormState>();
  final _privateKeyController = TextEditingController();

  late String privateKey;

  bool _agreedToTerms = false;

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
    privateKey = generatePrivate(_privateKeyController.text);
    super.initState();
  }

  @override
  void dispose() {
    _privateKeyController.dispose();

    super.dispose();
  }

  bool get _isFormValid => _privateKeyController.text.isNotEmpty;

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
                    ImportPrivateKey(controller: _privateKeyController),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Typically 64 alphanumeric characters'),
                    SizedBox(
                      height: 10,
                    ),
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
                    onPressed: _isFormValid ? () {} : null,
                    color: _isFormValid && _agreedToTerms
                        ? Colors.white
                        : Colors.grey[900],
                    text: 'Create Wallet',
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
