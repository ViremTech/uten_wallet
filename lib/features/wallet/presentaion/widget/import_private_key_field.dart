import 'package:flutter/material.dart';

class ImportPrivateKey extends StatefulWidget {
  final TextEditingController controller;

  const ImportPrivateKey({super.key, required this.controller});

  @override
  State<ImportPrivateKey> createState() => _ImportPrivateKeyState();
}

class _ImportPrivateKeyState extends State<ImportPrivateKey> {
  bool _obscure = true;
  String _actualText = '';

  void _handleChange(String value) {
    setState(() {
      _actualText = value;
      if (_obscure) {
        widget.controller.text = _maskSeed(value);
        widget.controller.selection =
            TextSelection.collapsed(offset: widget.controller.text.length);
      }
    });
  }

  String _maskSeed(String text) {
    return text.trim().split(' ').map((word) => '●' * word.length).join(' ');
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
      widget.controller.text = _obscure ? _maskSeed(_actualText) : _actualText;
      widget.controller.selection =
          TextSelection.collapsed(offset: widget.controller.text.length);
    });
  }

  @override
  void initState() {
    super.initState();
    _actualText = widget.controller.text;
    widget.controller.text = _obscure ? _maskSeed(_actualText) : _actualText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter your Private Key"),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          onChanged: _obscure ? _handleChange : (val) => _actualText = val,
          minLines: 3,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: _toggleObscure,
            ),
          ),
        ),
      ],
    );
  }
}
