import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/domain/usecase/get_active_wallet.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/generate_wallet_bloc/generate_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallet_home.dart';

import '../../../wallet/presentaion/bloc/get_active_wallet/get_active_wallet_bloc.dart';
import '../../../wallet/presentaion/bloc/set_active_wallet/set_active_wallet_bloc.dart';

class ConfirmSeed extends StatefulWidget {
  final List<String> correctSeed;
  const ConfirmSeed({super.key, required this.correctSeed});

  @override
  State<ConfirmSeed> createState() => _ConfirmSeedState();
}

class _ConfirmSeedState extends State<ConfirmSeed> {
  late List<String> _correctSeed;
  late List<int> confirmIndexes;
  late List<String?> userInput;
  late List<bool> isCorrect;
  late List<String> shuffledSeed;

  @override
  void initState() {
    super.initState();
    _correctSeed = widget.correctSeed;
    final rand = Random();
    confirmIndexes = [];

    while (confirmIndexes.length < 3) {
      int index = rand.nextInt(12);
      if (!confirmIndexes.contains(index)) {
        confirmIndexes.add(index);
      }
    }

    userInput = List.filled(3, null);
    isCorrect = List.filled(3, false);

    shuffledSeed = List<String>.from(_correctSeed);
    shuffledSeed.shuffle();
  }

  void handleWordTap(String word) {
    int emptyIndex = userInput.indexWhere((element) => element == null);
    if (emptyIndex == -1) return;

    setState(() {
      userInput[emptyIndex] = word;
      int confirmAt = confirmIndexes[emptyIndex];
      isCorrect[emptyIndex] = word == _correctSeed[confirmAt];
    });
  }

  void resetInput() {
    setState(() {
      userInput = List.filled(3, null);
      isCorrect = List.filled(3, false);
    });
  }

  bool allCorrect() => isCorrect.every((e) => e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirm Seed Phrase'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This is your seed phrase. Write it down on a paper and keep it in a safe place. You'll be asked to re-enter this phrase (in order) on the next step.",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: userInput[index] != null
                              ? isCorrect[index]
                                  ? Colors.green.shade100
                                  : Colors.red.shade100
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          userInput[index] ?? "${confirmIndexes[index] + 1}.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: shuffledSeed.map((word) {
                    bool isSelected = userInput.contains(word);

                    return GestureDetector(
                      onTap: isSelected ? null : () => handleWordTap(word),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.grey.shade300 : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          word,
                          style: TextStyle(
                            color: isSelected ? Colors.grey : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              MultiBlocListener(
                listeners: [
                  BlocListener<GenerateWalletBloc, GenerateWalletState>(
                    listener: (context, state) {
                      if (state is GenerateWalletSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Seed phrase confirmed successfully!',
                            ),
                          ),
                        );
                        context
                            .read<GetActiveWalletBloc>()
                            .add(LoadActiveWallet());
                      }
                      if (state is GenerateWalletFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message),
                          ),
                        );
                      }
                    },
                  ),
                  BlocListener<GetActiveWalletBloc, ActiveWalletState>(
                    listener: (context, state) {
                      if (state is ActiveWalletLoaded) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WalletHome(wallet: state.wallet as WalletModel),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
                child: BlocBuilder<GenerateWalletBloc, GenerateWalletState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: userInput
                                    .every((element) => element != null)
                                ? allCorrect()
                                    ? () {
                                        context.read<GenerateWalletBloc>().add(
                                              GenerateWalletRequested(
                                                mnemonic: widget.correctSeed
                                                    .join(" "),
                                                network: 'ethereum',
                                              ),
                                            );
                                      }
                                    : () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Incorrect seed phrase. Please try again.'),
                                          ),
                                        );
                                        resetInput();
                                      }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              disabledBackgroundColor: Colors.grey,
                              disabledForegroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        if (state is GenerateWalletLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black45,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
