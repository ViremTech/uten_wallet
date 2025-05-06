import 'package:flutter/material.dart';

import '../../../../core/constant/constant.dart';

class IconText extends StatelessWidget {
  final void Function()? onTap;
  final IconData? icon;
  final String text;
  const IconText(
      {super.key, required this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(
                  40,
                )),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
