import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_bloc.dart';
import 'package:uten_wallet/features/wallet/presentaion/bloc/get_all_wallet/wallet_state.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/add_existing_wallet.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/create_new_wallet_screen.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/listtile_widget.dart';

import '../bloc/get_all_wallet/wallet_event.dart';

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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Wallets',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              size: 24,
            ),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 24,
            ),
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WalletLoaded) {
              List<WalletEntity> wallets = state.wallets;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Multi-coin wallets',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        return Container(
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
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.white,
                                  )),
                            ),
                            title: Text(wallets[0].name),
                            trailing: Icon(
                              Icons.more_vert,
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
              return Center(
                child: Text(
                  'Unable to get All Wallet',
                ),
              );
            }
          },
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
          padding: EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/addwallet.png',
              ),
              SizedBox(
                height: 20,
              ),
              ListtileWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNewWalletScreen(),
                    ),
                  );
                },
                title: 'Create new wallet',
                subtitle: 'Secret phrase',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                child: Icon(Icons.star_half_sharp),
              ),
              SizedBox(
                height: 20,
              ),
              ListtileWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExistingWallet(
                        model: model,
                      ),
                    ),
                  );
                },
                title: 'Add existing wallet',
                subtitle: 'Import, restore',
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
                child: Icon(
                  Icons.download,
                  size: 15,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
