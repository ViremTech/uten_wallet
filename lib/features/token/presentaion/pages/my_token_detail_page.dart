import 'package:flutter/material.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';
import 'package:uten_wallet/features/token/presentaion/widget/time_filter_tabbar.dart';

class MyTokenDetailPage extends StatefulWidget {
  final TokenModel tokenModel;
  const MyTokenDetailPage({super.key, required this.tokenModel});

  @override
  State<MyTokenDetailPage> createState() => _MyTokenDetailPageState();
}

class _MyTokenDetailPageState extends State<MyTokenDetailPage> {
  TimeFilter _currentFilter = TimeFilter.today;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  maxRadius: 15,
                  backgroundImage: NetworkImage(
                    widget.tokenModel.logoURI,
                  ),
                ),
                Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[800],
                  ),
                  child: Center(
                    child: Text(
                      'Watch',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text('${widget.tokenModel.name} price'),
            Text(
              '\$${widget.tokenModel.tokenPrice.usdPrice}',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.tokenModel.tokenPrice.precentageChange.toStringAsFixed(2)}%',
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Placeholder(
                child: Center(
                  child: Text(
                    'Chart',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TimeFilterTabBar(onFilterChanged: (filter) {
              setState(() {
                _currentFilter = filter;
              });
            }),
            SizedBox(
              height: 30,
            ),
            Text('Data')
          ],
        ),
      ),
    );
  }
}
