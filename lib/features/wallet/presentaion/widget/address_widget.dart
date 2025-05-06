import 'package:flutter/material.dart';

import '../../../../core/util/copy_address.dart';

class AddressWidget extends StatelessWidget {
  final String address;
  final String shortAddress;
  const AddressWidget(
      {super.key, required this.address, required this.shortAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 118,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.white,
          width: 0.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Ethereum address'),
              Text(
                shortAddress,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Image.asset(
                'assets/images/group.png',
                width: 95,
                height: 20,
              ),
            ],
          ),
          Row(
            children: [
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
                  Icons.copy,
                  size: 24,
                ),
                tooltip: 'Copy address',
                onPressed: () {
                  copyToClipboard(
                    context,
                    address,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
