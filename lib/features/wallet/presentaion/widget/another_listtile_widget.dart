import 'package:flutter/material.dart';
import 'package:uten_wallet/core/constant/constant.dart';

class AnotherListTileWidget extends StatelessWidget {
  final void Function()? onTap;
  final String title;

  final Widget? child;
  const AnotherListTileWidget(
      {super.key,
      required this.onTap,
      required this.title,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[900], borderRadius: BorderRadius.circular(5)),
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
              child: child),
          title: Text(title),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
        ),
      ),
    );
  }
}
