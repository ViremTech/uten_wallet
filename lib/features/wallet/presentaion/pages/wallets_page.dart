import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_state.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_event.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/delete_wallet/delete_wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/add_existing_wallet.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/create_new_wallet_screen.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/listtile_widget.dart';

import '../bloc/set_active_wallet/set_active_wallet_bloc.dart';

class WalletsPage extends StatefulWidget {
  final WalletModel model;
  const WalletsPage({super.key, required this.model});

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  @override
  void initState() {
    context.read<WalletBloc>().add(FetchAllWallets());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteWalletBloc, DeleteWalletState>(
          listener: (context, state) {
            if (state is DeleteWalletSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Wallet deleted successfully')),
              );
              context.read<WalletBloc>().add(FetchAllWallets());
            } else if (state is DeleteWalletFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<SetMyActiveWalletBloc, SetMyActiveWalletState>(
          listener: (context, state) {
            if (state is SetMyActiveWalletSuccess) {
              // Re-fetch wallets to update UI
              context.read<WalletBloc>().add(FetchAllWallets());

              // Show snackbar with wallet name
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${state.walletName} is now the active wallet')),
              );
            } else if (state is SetMyActiveWalletFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to set active wallet: ${state.message}')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Wallets'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 24),
              tooltip: 'Notifications',
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 24),
              tooltip: 'Settings',
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is WalletLoaded) {
                List<WalletEntity> wallets = state.wallets;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Multi-coin wallets'),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: wallets.length,
                        itemBuilder: (context, index) {
                          final wallet = wallets[index];
                          final isActive = wallet.isActive;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5),
                                border: isActive
                                    ? Border.all(color: primaryColor, width: 2)
                                    : null,
                              ),
                              padding: const EdgeInsets.all(7),
                              child: ListTile(
                                leading: Stack(
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.transparent,
                                        border: Border.all(
                                            width: 0.5, color: Colors.white),
                                      ),
                                    ),
                                    if (isActive)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black, width: 1),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(wallet.name),
                                onTap: () {
                                  context.read<SetMyActiveWalletBloc>().add(
                                        SetActiveWalletRequested(
                                            wallet.id, wallet.name),
                                      );
                                },
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      context.read<DeleteWalletBloc>().add(
                                            DeleteWalletRequested(wallet.id),
                                          );
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: ButtonWidget(
                        paddng: 8,
                        onPressed: () {
                          _showModalBottomSheet(context, widget.model);
                        },
                        color: primaryColor,
                        text: 'Add Wallet',
                        textColor: Colors.black,
                      ),
                    )
                  ],
                );
              } else {
                return const Center(child: Text('Unable to get All Wallet'));
              }
            },
          ),
        ),
      ),
    );
  }
}

void _showModalBottomSheet(BuildContext context, WalletModel model) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/images/addwallet.png'),
              const SizedBox(height: 20),
              ListtileWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateNewWalletScreen()),
                  );
                },
                title: 'Create new wallet',
                subtitle: 'Secret phrase',
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                child: const Icon(Icons.star_half_sharp),
              ),
              const SizedBox(height: 20),
              ListtileWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExistingWallet(model: model),
                    ),
                  );
                },
                title: 'Add existing wallet',
                subtitle: 'Import, restore',
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                child: const Icon(Icons.download, size: 15),
              ),
            ],
          ),
        ),
      );
    },
  );
}
