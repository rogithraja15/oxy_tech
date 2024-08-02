import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:oxy_tech/screens/login.dart';
import 'package:oxy_tech/services/auth_services.dart';
import 'package:oxy_tech/utils/constants.dart';
import 'package:oxy_tech/widgets/button.dart';
import 'package:oxy_tech/widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _retypePasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _retypePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _onChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  void _onLoginPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _retypePasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required.')),
      );
      return false;
    }
    if (_passwordController.text != _retypePasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return false;
    }
    if (!_isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must agree to the terms and privacy.')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: sizew(context) * 0.7,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
              gradient: customGradient2,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close, color: Colors.white)),
                ),
                Positioned(
                  left: 25,
                  bottom: 25,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Let\'s\n',
                          style: AppTheme.headingTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(
                            text: 'Create\nYour\nAccount',
                            style: AppTheme.headingTextStyle),
                      ],
                      style: const TextStyle(
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                CustomTextField(
                    controller: _nameController,
                    icon: Icons.person,
                    hintText: 'Full Name'),
                CustomTextField(
                    controller: _emailController,
                    icon: Icons.mail_outline_outlined,
                    hintText: 'Email Address'),
                CustomTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Password'),
                CustomTextField(
                    controller: _retypePasswordController,
                    icon: Icons.lock,
                    hintText: 'Retype Password'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        side: const BorderSide(width: 0.5),
                        activeColor: AppTheme.primaryColor,
                        value: _isChecked,
                        onChanged: _onChanged,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTheme.hintTextStyle(context)
                            .copyWith(fontSize: sizew(context) * 0.03),
                        children: const <TextSpan>[
                          TextSpan(
                            text: 'I agree to the ',
                          ),
                          TextSpan(
                            text: 'Terms & Privacy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                CustomButton(
                    onPressed: () async {
                      if (_validateInputs()) {
                        await AuthService().register(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context,
                        );
                      }
                    },
                    text: 'Sign Up'),
                SizedBox(height: sizeh(context) * 0.03),
                RichText(
                  text: TextSpan(
                    style: AppTheme.hintTextStyle(context)
                        .copyWith(fontSize: sizew(context) * 0.03),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Have an account?  ',
                      ),
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onLoginPressed,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
