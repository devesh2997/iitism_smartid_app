import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String admnNo;
  String password;
  TextEditingController admnNoController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    admnNoController = TextEditingController();
    passwordController = TextEditingController();
    admnNoController.addListener(_changeAdmissionNumber);
    passwordController.addListener(_changePassword);
  }

  @override
  void dispose() {
    admnNoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _changeAdmissionNumber() {
    setState(() {
      admnNo = admnNoController.text;
    });
  }

  _changePassword() {
    setState(() {
      password = passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: (authProvider.status == AuthStatus.Authenticating)
          ? CircularProgressIndicator()
          : FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await authProvider.login(admnNo, password);
                }
              },
              child: Icon(Icons.keyboard_arrow_right),
            ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64),
            child: Row(
              children: <Widget>[
                Text(
                  'SmartID',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 160,
                color: Colors.transparent,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'User Login ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: admnNoController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter admission number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Admission number',
                          hintText: '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Text(authProvider.error ?? ''),
        ],
      ),
    );
  }
}
