import 'package:flutter/material.dart';

import '../widgets/input_with_label.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = "/sign-in";
  final headingText = "Welcome back!";
  final subHeadingText = "Sign in to your account";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  headingText,
                  style: textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Text(
                  subHeadingText,
                  style: textTheme.headline6,
                ),
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
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Forgot password?",
                    textAlign: TextAlign.end,
                    // style: textTheme.headline6,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
