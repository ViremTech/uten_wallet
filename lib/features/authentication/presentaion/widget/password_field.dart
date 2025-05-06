import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final void Function()? onPressed;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  final bool obscureText;
  final String hintText;
  const PasswordField(
      {super.key,
      required this.onPressed,
      required this.controller,
      required this.validator,
      required this.obscureText,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: onPressed),
      ),
    );
  }
}
