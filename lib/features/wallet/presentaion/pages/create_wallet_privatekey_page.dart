import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/import_wallet_bloc/import_wallet_bloc.dart';

import 'package:uten_wallet/features/wallet/presentaion/pages/wallets_page.dart';

import '../../../onboarding/presentaion/widget/button_widget.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

import '../widget/import_private_key_field.dart';

class CreateWalletWithPrivateKey extends StatefulWidget {
  final WalletModel model;
  const CreateWalletWithPrivateKey({super.key, required this.model});

  @override
  State<CreateWalletWithPrivateKey> createState() =>
      _CreateWalletWithPrivateKeyState();
}

class _CreateWalletWithPrivateKeyState
    extends State<CreateWalletWithPrivateKey> {
  final _formKey = GlobalKey<FormState>();
  final _privateKeyController = TextEditingController();

  bool _agreedToTerms = false;

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
                              builder: (context) => WalletsPage(
                                  model: state.wallet as WalletModel),
                            ),
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
                            context.read<ImportWalletBloc>().add(
                                  ImportWalletRequested(
                                    privateKey: _privateKeyController.text,
                                    network: widget.model.network,
                                  ),
                                );
                          }
                        : null,
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
