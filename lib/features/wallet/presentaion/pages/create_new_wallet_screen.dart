import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/widget/snackbar.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';

import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/mnemonic_bloc/generate_mnemonic_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallets_page.dart';

import '../../../../core/constant/constant.dart';

class CreateNewWalletScreen extends StatefulWidget {
  const CreateNewWalletScreen({super.key});

  @override
  State<CreateNewWalletScreen> createState() => _CreateNewWalletScreenState();
}

class _CreateNewWalletScreenState extends State<CreateNewWalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(7),
              child: ListTile(
                leading: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      30,
                    ),
                    color: primaryColor,
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  child: Icon(Icons.security),
                ),
                title: Text('Seed Phrase'),
                trailing: SizedBox(
                  width: 110,
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<GenerateMnemonicBloc, GenerateMnemonicState>(
                        listener: (context, state) {
                          if (state is GenerateMnemonicSuccess) {
                            context.read<GenerateWalletBloc>().add(
                                  GenerateWalletRequested(
                                    mnemonic: state.mnemonic,
                                    network: 'ethereum',
                                  ),
                                );
                          }
                          if (state is GenerateMnemonicFailure) {
                            mySnackBar(state.message, context);
                          }
                        },
                      ),
                      BlocListener<GenerateWalletBloc, GenerateWalletState>(
                        listener: (context, state) {
                          if (state is GenerateWalletSuccess) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WalletsPage(
                                    model: state.wallet as WalletModel,
                                  ),
                                ),
                                (route) => false);
                            mySnackBar(
                                'New Wallet Generated Successfull', context);
                          }
                        },
                      ),
                    ],
                    child: ButtonWidget(
                        paddng: 0,
                        onPressed: () {
                          context
                              .read<GenerateMnemonicBloc>()
                              .add(GenerateMnemonicRequested());
                        },
                        color: primaryColor,
                        text: 'Create',
                        textColor: Colors.white),
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
