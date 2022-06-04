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

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId ?? "";
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

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

    _token = data["idToken"];
    _userId = data["localId"];

    final expiresIn = int.parse(data["expiresIn"]);
    _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;

    notifyListeners();
  }
}
