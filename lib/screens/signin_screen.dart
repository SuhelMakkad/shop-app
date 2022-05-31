import 'package:flutter/material.dart';

import '../widgets/input_with_label.dart';

enum AuthMode { signup, login }

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  static const routeName = "/sign-in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthMode _authMode = AuthMode.login;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: _authMode == AuthMode.login
                    ? "Welcome back"
                    : "Welcome aboard",
                style: textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "!",
                    style: textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _authMode == AuthMode.login
                  ? "Sign in to your account"
                  : "Create a new account",
              style: textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 24,
            ),
            const InputWithLabel(
              label: "Email",
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 12,
            ),
            InputWithLabel(
              label: "Password",
              obscureText: true,
              textInputAction: _authMode == AuthMode.login
                  ? TextInputAction.done
                  : TextInputAction.next,
            ),
            if (_authMode == AuthMode.signup)
              Column(
                children: const [
                  SizedBox(
                    height: 12,
                  ),
                  InputWithLabel(
                    label: "Confirm",
                    obscureText: true,
                    allowObscureToggle: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            const SizedBox(
              height: 2,
            ),
            if (_authMode == AuthMode.login)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password?",
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
                child: Text(
                  _authMode == AuthMode.login ? "Continue" : "Create Account",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _authMode == AuthMode.login
                      ? "Don't have an account?"
                      : "Already have an account?",
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_authMode == AuthMode.login) {
                        _authMode = AuthMode.signup;
                      } else {
                        _authMode = AuthMode.login;
                      }
                    });
                  },
                  child: Text(
                    _authMode == AuthMode.login ? "Sign up" : "Login",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
