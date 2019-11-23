import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/constansts.dart';
import 'package:iitism_smartid_app/models/user.dart';
import 'package:iitism_smartid_app/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Refreshing
}

class AuthProvider extends ChangeNotifier {
  AuthStatus status;
  User user;
  String token;
  String error;
  bool refreshing;

  AuthProvider.instance()
      : status = AuthStatus.Uninitialized,
        refreshing = false {
    _init();
  }

  Map<String, String> getHeaders() {
    Map<String, String> mp = Map();
    mp['Authorization'] = 'Bearer ' + this.token;
    mp['Content-Type'] = "application/json";
    return mp;
  }

  _init() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map userData = json.decode(prefs.get('currentUser'));
      user = User.fromMap(userData);
      token = prefs.getString('token');
      if (user != null && token != null) {
        status = AuthStatus.Authenticated;
      } else {
        status = AuthStatus.Unauthenticated;
      }
    } catch (error) {
      status = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String admnNo, String password) async {
    Map<String, String> mp = Map();
    mp['admn_no'] = admnNo;
    mp['password'] = password;
    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      Response response = await http.post(BASE_URL + 'users/login', body: mp);
      Map<String, dynamic> parsedResponse;
      parsedResponse = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (parsedResponse['success']) {
        prefs.setString('token', parsedResponse['token']);
        prefs.setString('currentUser', json.encode(parsedResponse['user']));
        user = User.fromMap(parsedResponse['user']);
        token = parsedResponse['token'];
        status = AuthStatus.Authenticated;
      } else {
        error = parsedResponse['error'];
        status = AuthStatus.Unauthenticated;
      }
    } catch (e) {
      error = e.toString();
      status = AuthStatus.Unauthenticated;
    }
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    refreshing = true;
    notifyListeners();
    try {
      Response response = await http.get(BASE_URL + 'user/' + user.admnNo,
          headers: getHeaders());
      Map<String, dynamic> parsedResponse;
      parsedResponse = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (parsedResponse['success']) {
        prefs.setString('currentUser', json.encode(parsedResponse['user']));
        user = User.fromMap(parsedResponse['user']);
      } else {
        error = parsedResponse['error'];
        await logout();
      }
    } catch (e) {
      error = e.toString();
      await logout();
    }
    refreshing = false;
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('currentUser');
    prefs.remove('token');
    token = null;
    user = null;
    status = AuthStatus.Unauthenticated;
    notifyListeners();
  }
}
