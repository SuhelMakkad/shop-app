import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

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

  Future<void> _storeUseDataInPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      "authToken": _token!,
      "userId": _userId,
      "expiryDate": _expiryDate!.toIso8601String(),
    };
    prefs.setString("userData", json.encode(userData));
  }

  Future<Map<String?, Object?>?> _getUseDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return null;
    }

    final userData = prefs.getString("userData")!;
    final userDataParsed = json.decode(userData) as Map<String, Object>;
    return userDataParsed;
  }

  Future<bool> tryAutoLogin() async {
    final userData = await _getUseDataFromPrefs();
    if (userData == null) {
      return false;
    }

    final expiryDate = DateTime.parse(userData["expiryDate"] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData["authToken"] as String;
    _userId = userData["userId"] as String;

    notifyListeners();

    return true;
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

    _autoLogout();
    notifyListeners();
    _storeUseDataInPrefs();
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
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeTilExpire = _expiryDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(
      Duration(seconds: timeTilExpire),
      logout,
    );
  }
}
