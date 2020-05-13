import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/data/transactions_repository.dart';
import 'package:iitism_smartid_app/models/user.dart';
import 'package:iitism_smartid_app/providers/auth_provider.dart';
import 'package:iitism_smartid_app/widgets/transactions.dart';
import 'package:provider/provider.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      builder: (context) => TransactionRepository.instance(authProvider),
      child: LandingBase(),
    );
  }
}

class LandingBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    TransactionRepository transactionRepository =
        Provider.of<TransactionRepository>(context);
    User user = authProvider.user;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: authProvider.refreshing ||
              transactionRepository.status == Status.Loading
          ? CircularProgressIndicator()
          : FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                Provider.of<AuthProvider>(context).refreshUserData();
                Provider.of<TransactionRepository>(context).refresh();
              }),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 16),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '\u20B9 ' + authProvider.user.balance.toString(),
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TransactionList(),
          Container(
            color: Colors.blue,
            padding: EdgeInsets.only(top: 32, left: 16,right: 16,bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  user.firstName + ' ' + user.lastName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => authProvider.logout(),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
