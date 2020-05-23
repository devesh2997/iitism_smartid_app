import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/constansts.dart';
import 'package:iitism_smartid_app/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:iitism_smartid_app/models/user.dart';
import 'package:iitism_smartid_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

enum Status { Uninitialized, Success, Error, Loading, NotAuthenticated }

class TransactionRepository extends ChangeNotifier {
  Status status;
  List<Transaction> transactions;
  AuthProvider authProvider;

  TransactionRepository.instance(AuthProvider authProvider)
      : status = Status.Uninitialized {
    this.authProvider = authProvider;
    transactions = List<Transaction>();
    _init();
  }

  Future<void> _init() async {
    status = Status.Loading;
    notifyListeners();
    try {
      if (authProvider.status == AuthStatus.Authenticated) {
        Response response = await http.post(
            BASE_URL + 'user/transactions.php',body: {
              'jwt':authProvider.getToken(),
              'id':authProvider.user.admnNo
            });
        Map<String, dynamic> parsedResponse;
        parsedResponse = json.decode(response.body);
        if (parsedResponse['success']) {
          this.transactions = List<Transaction>();
          status = Status.Success;
          List<dynamic> ts = parsedResponse['transactions'];
          for (int i = 0; i < ts.length; i++) {
            transactions.add(Transaction.fromMap(ts[i]));
          }
        } else {
          status = Status.Error;
        }
      } else {
        status = Status.NotAuthenticated;
      }
    } catch (e) {
      print(e);
      status = Status.Error;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    _init();
  }
}
