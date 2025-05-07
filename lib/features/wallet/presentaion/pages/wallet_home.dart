import 'package:flutter/material.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/receieve_page.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallets_page.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/Icon_text_widget.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/address_widget.dart';

import '../../../../core/util/truncate_address.dart';

class WalletHome extends StatefulWidget {
  final WalletEntity wallet;
  const WalletHome({super.key, required this.wallet});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  bool hasToken = false;
  bool hasNfts = false;
  bool hasDefi = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WalletsPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.wallet.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.copy,
                            size: 24,
                          ),
                          tooltip: 'Copy address',
                          onPressed: () {
                            receiveAssets(
                              context,
                              widget.wallet.address,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            size: 24,
                          ),
                          tooltip: 'Scan QR',
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 24,
                          ),
                          tooltip: 'Notifications',
                          onPressed: () {},
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "USD ${widget.wallet.balance}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconText(
                      text: 'Buy',
                      onTap: () {},
                      icon: Icons.add,
                    ),
                    IconText(
                      text: 'Swap',
                      onTap: () {},
                      icon: Icons.swap_horiz,
                    ),
                    IconText(
                      text: 'Bridge',
                      onTap: () {},
                      icon: Icons.navigate_next,
                    ),
                    IconText(
                      text: 'Send',
                      onTap: () {},
                      icon: Icons.arrow_upward_outlined,
                    ),
                    IconText(
                      text: 'Receive',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReceievePage(
                              wallet: widget.wallet,
                            ),
                          ),
                        );
                      },
                      icon: Icons.arrow_downward_outlined,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TabBar(
                  dividerHeight: 0,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(
                      text: 'Crypto',
                    ),
                    Tab(
                      text: 'NFTs',
                    ),
                    Tab(
                      text: 'DeFi',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      hasToken
                          ? ListView.builder(itemBuilder: (context, index) {
                              return ListTile();
                            })
                          : Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Image.asset('assets/images/home1.png'),
                                      Text(
                                        'Add crypto to get started',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'You can add funds with your Uten account or another wallet.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: ButtonWidget(
                                      paddng: 0,
                                      onPressed: () {},
                                      color: primaryColor,
                                      text: 'Add Cryto',
                                      textColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      hasNfts
                          ? ListView.builder(itemBuilder: (context, index) {
                              return ListTile();
                            })
                          : Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Image.asset('assets/images/home2.png'),
                                      Text(
                                        'Get Started with NFTs',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "First you'll need to add some ETH to your wallet",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: ButtonWidget(
                                      paddng: 0,
                                      onPressed: () {},
                                      color: primaryColor,
                                      text: 'Add Cryto',
                                      textColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      hasDefi
                          ? ListView.builder(itemBuilder: (context, index) {
                              return ListTile();
                            })
                          : Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Image.asset('assets/images/home3.png'),
                                      Text(
                                        'Start earning with DeFi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Add crypto you wallet to get started with decentralized finances',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: ButtonWidget(
                                      paddng: 0,
                                      onPressed: () {},
                                      color: primaryColor,
                                      text: 'Add Cryto',
                                      textColor: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade800,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          iconSize: 24,
          showUnselectedLabels: true,
          selectedFontSize: 9,
          unselectedFontSize: 9,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Assets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              label: 'Browser',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

void receiveAssets(BuildContext context, String address) {
  String shortAddress = truncateAddress(address);
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            padding: EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receive assets',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 20,
                ),
                AddressWidget(address: address, shortAddress: shortAddress)
              ],
            ),
          ),
        );
      });
}
