import 'package:flutter/material.dart';
import 'package:oxy_tech/screens/register.dart';
import 'package:oxy_tech/services/auth_services.dart';
import 'package:oxy_tech/utils/constants.dart';
import 'package:oxy_tech/widgets/button.dart';
import 'package:oxy_tech/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: customGradient,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 80.0, vertical: 50),
              child: Image.asset('assets/login_logo.png'),
            ),
            Text(
              'OxyTech',
              style: TextStyle(
                  shadows: const <Shadow>[
                    Shadow(
                        offset: Offset(0.0, 4.0),
                        blurRadius: 4.0,
                        color: Colors.black),
                  ],
                  fontSize: sizew(context) * 0.1,
                  color: const Color(0xffEDB232),
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                children: [
                  SizedBox(height: sizeh(context) * 0.025),
                  CustomTextField2(
                      controller: _emailController,
                      icon: Icons.person,
                      hintText: 'Email'),
                  CustomTextField2(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hintText: 'Password'),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: sizeh(context) * 0.025),
                  CustomButton(
                      onPressed: () async {
                        await AuthService().login(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context,
                        );
                      },
                      text: 'Login'),
                  SizedBox(height: sizeh(context) * 0.01),
                  const Text(
                    'Or',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: sizeh(context) * 0.01),
                  CustomButton2(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()));
                      },
                      text: 'Create an account')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
