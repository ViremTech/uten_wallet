import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/widget/snackbar.dart';

import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';

import 'package:uten_wallet/features/wallet/presentaion/pages/wallets_page.dart';
import '../../../authentication/presentaion/widget/seed_phrase_field.dart';
import '../../../onboarding/presentaion/widget/button_widget.dart';

class CreateWithSeedPhrase extends StatefulWidget {
  const CreateWithSeedPhrase({super.key});

  @override
  State<CreateWithSeedPhrase> createState() => _CreateWithSeedPhraseState();
}

class _CreateWithSeedPhraseState extends State<CreateWithSeedPhrase> {
  final _formKey = GlobalKey<FormState>();
  final _seedController = TextEditingController();

  late String privateKey;

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _seedController.dispose();

    super.dispose();
  }

  bool get _isFormValid => _seedController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Wallet'), centerTitle: true),
      body: BlocListener<GenerateWalletBloc, GenerateWalletState>(
        listener: (context, state) {
          if (state is GenerateWalletSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletsPage(
                  model: state.wallet as WalletModel,
                ),
              ),
            );
            mySnackBar('Wallet Imported successfully', context);
          }
          if (state is GenerateWalletFailure) {
            mySnackBar(state.message, context);
          }
        },
        child: Column(
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
                child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ButtonWidget(
                    paddng: 16,
                    onPressed: _isFormValid
                        ? () {
                            context.read<GenerateWalletBloc>().add(
                                  GenerateWalletRequested(
                                    mnemonic: _seedController.text,
                                    network: 'ethereum',
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
          ],
        ),
      ),
    );
  }
}
