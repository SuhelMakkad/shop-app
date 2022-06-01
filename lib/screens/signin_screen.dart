import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

import '../widgets/input_with_label.dart';

enum AuthMode { signup, login }

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = "/sign-in";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  AuthMode _authMode = AuthMode.login;

  Future<void> _submit() async {
    final formState = _formKey.currentState!;
    if (!formState.validate()) {
      // Invalid!
      return;
    }
    formState.save();
    setState(() {
      _isLoading = true;
    });
    final authData = Provider.of<Auth>(context, listen: false);
    if (_authMode == AuthMode.login) {
      await authData.login(_authData["email"]!, _authData["password"]!);
      // Log user in
    } else {
      await authData.signup(_authData["email"]!, _authData["password"]!);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
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
                    height: 36,
                  ),
                  InputWithLabel(
                    label: "Email",
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return "Invalid email!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData["email"] = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputWithLabel(
                    label: "Password",
                    obscureText: true,
                    controller: _passwordController,
                    textInputAction: _authMode == AuthMode.login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return "Password is too short!";
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _authData["password"] = value!;
                    },
                  ),
                  if (_authMode == AuthMode.signup)
                    Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        InputWithLabel(
                          label: "Confirm",
                          obscureText: true,
                          allowObscureToggle: true,
                          enabled: _authMode == AuthMode.signup,
                          validator: _authMode == AuthMode.login
                              ? null
                              : (value) {
                                  if (value != _passwordController.text) {
                                    return "Password and Confirm Password do not match!";
                                  }
                                  return null;
                                },
                        ),
                        const SizedBox(
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
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        primary: themeData.colorScheme.primary.withOpacity(
                          _isLoading ? 0.5 : 1,
                        ),
                      ),
                      child: Text(
                        _authMode == AuthMode.login
                            ? "Continue"
                            : "Create Account",
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
          ),
        ),
      ),
    );
  }
}
