import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color? color;
  final String text;
  final Color? textColor;
  final double paddng;
  final void Function()? onPressed;
  const ButtonWidget(
      {super.key,
      required this.paddng,
      required this.onPressed,
      required this.color,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddng),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              50,
            )),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
