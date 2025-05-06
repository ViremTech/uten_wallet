import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/create_seedphrase_screen.dart';

import '../../../onboarding/presentaion/widget/button_widget.dart';
import '../../../wallet/presentaion/bloc/mnemonic_bloc/generate_mnemonic_bloc.dart';

class SecureWalletDetail extends StatefulWidget {
  const SecureWalletDetail({super.key});

  @override
  State<SecureWalletDetail> createState() => _SecureWalletDetailState();
}

class _SecureWalletDetailState extends State<SecureWalletDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Secure Your Wallet'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        "Secure Your Wallet's",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        " seed phrase",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(
                              30,
                            )),
                        child: Icon(
                          Icons.question_mark_outlined,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Why is it important?',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Write down your seed phrase on a cryptooly of paper and store in a safe place.',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        'Password strength: ',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      Text(
                        'Good',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.green,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            3,
                          ),
                        ),
                      ),
                    );
                  })),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '''
Risks are: 
• You lose it
• You forget where you put it
• Someone else finds it
                  ''',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                          height: 2,
                        ),
                  ),
                  Text(
                    "Other options: Doesn't have to be paper!,",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '''
Tips:
• Store in bank vault
• Store in a safe
• Store in multiple secret places
                  ''',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                          height: 2,
                        ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                ),
                child:
                    BlocListener<GenerateMnemonicBloc, GenerateMnemonicState>(
                  listener: (context, state) {
                    if (state is GenerateMnemonicSuccess) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateSeedphraseScreen(
                                    mnemonic: state.mnemonic,
                                  )),
                          (route) => false);
                    }
                    if (state is GenerateMnemonicFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                          ),
                        ),
                      );
                    }
                  },
                  child: ButtonWidget(
                    color: Colors.white,
                    text: 'Start',
                    onPressed: () {
                      context.read<GenerateMnemonicBloc>().add(
                            GenerateMnemonicRequested(),
                          );
                    },
                    paddng: 16,
                    textColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
