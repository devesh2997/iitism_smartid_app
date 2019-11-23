import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/providers/auth_provider.dart';
import 'package:iitism_smartid_app/screens/login_page.dart';
import 'package:provider/provider.dart';

class WithAuthentication extends StatelessWidget {
  final Widget child;
  WithAuthentication({this.child});
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, AuthProvider auth, _) {
      switch (auth.status) {
        case AuthStatus.Authenticating:
        case AuthStatus.Unauthenticated:
          return LoginPage();
        case AuthStatus.Authenticated:
          return child;
        case AuthStatus.Uninitialized:
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        default:
          return LoginPage();
      }
    });
  }
}
