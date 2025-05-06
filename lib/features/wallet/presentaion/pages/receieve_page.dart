import 'package:flutter/material.dart';
import 'package:uten_wallet/core/util/truncate_address.dart';
import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/address_widget.dart';

class ReceievePage extends StatefulWidget {
  final WalletEntity wallet;
  const ReceievePage({super.key, required this.wallet});

  @override
  State<ReceievePage> createState() => _ReceievePageState();
}

class _ReceievePageState extends State<ReceievePage> {
  @override
  Widget build(BuildContext context) {
    final shortAddress = truncateAddress(widget.wallet.address);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Receive cryptos and NFTs',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TabBar(
                dividerHeight: 0,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(
                    text: 'Address',
                  ),
                  Tab(
                    text: 'Username',
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(children: [
                  Column(
                    children: [
                      AddressWidget(
                          address: widget.wallet.address,
                          shortAddress: shortAddress)
                    ],
                  ),
                  Column(
                    children: [],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
