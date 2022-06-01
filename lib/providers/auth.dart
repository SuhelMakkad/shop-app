import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  final _firebaseAuthBaseUrl = "https://identitytoolkit.googleapis.com";
  final _firebaseWebAPIKey = "AIzaSyBuBjTJe4zfYqS8hz0ltuzXLVyxLYY4gN4";

  Future<void> _authenticate(
    String email,
    String password,
    String routeName,
  ) async {
    final url = Uri.parse(
        "$_firebaseAuthBaseUrl/v1/accounts:$routeName?key=$_firebaseWebAPIKey");

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    final data = json.decode(response.body);

    if (data["error"] != null) {
      throw HttpException(data["error"]["message"]);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
