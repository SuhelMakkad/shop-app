import 'package:flutter/material.dart';

import '../widgets/input_with_label.dart';

enum AuthMode { signup, login }

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  static const routeName = "/sign-in";

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
                text: "Welcome back",
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
            const SizedBox(height: 8),
            Text(
              "Sign in to your account",
              style: textTheme.titleMedium,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            const InputWithLabel(
              label: "Email",
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            const InputWithLabel(
              label: "Password",
              isTextHideable: true,
            ),
            const SizedBox(height: 2),
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
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
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
