import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/bloc/auth_bloc.dart';
import 'package:uten_wallet/features/authentication/presentaion/pages/secure_wallet_screen.dart';
import 'package:uten_wallet/features/authentication/presentaion/widget/password_field.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';

import '../../../../core/constant/constant.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  bool _confirmObscureText = true;

  String? _passwordError;
  String? _confirmPasswordError;

  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasMinLength = false;
  bool _passwordsMatch = false;

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);

      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (!_hasMinLength) {
        _passwordError = 'Password must be at least 8 characters';
      } else if (!_hasUppercase) {
        _passwordError = 'Password must contain an uppercase letter';
      } else if (!_hasNumber) {
        _passwordError = 'Password must contain a number';
      } else {
        _passwordError = null;
      }

      if (_confirmPasswordController.text.isNotEmpty) {
        _validateConfirmPassword();
      }

      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
  }

  void _validateConfirmPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
        _passwordsMatch = false;
      } else if (password != confirmPassword) {
        _confirmPasswordError = 'Passwords do not match';
        _passwordsMatch = false;
      } else {
        _confirmPasswordError = null;
        _passwordsMatch = true;
      }

      if (_formKey.currentState != null) {
        _formKey.currentState!.validate();
      }
    });
  }

  bool get _isFormValid =>
      _passwordError == null &&
      _confirmPasswordError == null &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordsMatch &&
      _agreedToTerms;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Create Password',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'This password will unlock your Uten wallet only on this service',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password'),
                            SizedBox(height: 8),
                            PasswordField(
                              hintText: 'Password',
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              controller: _passwordController,
                              validator: (_) => _passwordError,
                              obscureText: _obscureText,
                            ),
                            SizedBox(height: 10),
                            PasswordRequirementsList(
                              hasMinLength: _hasMinLength,
                              hasUppercase: _hasUppercase,
                              hasNumber: _hasNumber,
                            ),
                            SizedBox(height: 25),
                            Text('Confirm Password'),
                            SizedBox(height: 8),
                            PasswordField(
                              hintText: 'Confirm Password',
                              onPressed: () {
                                setState(() {
                                  _confirmObscureText = !_confirmObscureText;
                                });
                              },
                              controller: _confirmPasswordController,
                              validator: (_) => _confirmPasswordError,
                              obscureText: _confirmObscureText,
                            ),
                            SizedBox(height: 10),
                            AnimatedOpacity(
                              opacity:
                                  (_confirmPasswordController.text.isNotEmpty &&
                                          _passwordsMatch)
                                      ? 1.0
                                      : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Passwords match',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreedToTerms,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _agreedToTerms = value ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to the Terms of Service and Privacy Policy',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecureWalletScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password created successfully!')),
                    );
                  }
                },
                child: Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ButtonWidget(
                    paddng: 16,
                    onPressed: _isFormValid && _agreedToTerms
                        ? () {
                            context.read<AuthBloc>().add(
                                  SavePasswordEvent(
                                      password:
                                          _confirmPasswordController.text),
                                );
                          }
                        : null,
                    color: _isFormValid && _agreedToTerms
                        ? Colors.white
                        : Colors.grey[900],
                    text: 'Next',
                    textColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordRequirementsList extends StatelessWidget {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasNumber;

  const PasswordRequirementsList({
    Key? key,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRequirement('At least 8 characters', hasMinLength),
          _buildRequirement('At least one uppercase letter', hasUppercase),
          _buildRequirement('At least one number', hasNumber),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              key: ValueKey<bool>(isMet),
              color: isMet ? Colors.green : Colors.grey,
              size: 16,
            ),
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isMet ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
