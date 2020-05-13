import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/providers/auth_provider.dart';
import 'package:iitism_smartid_app/providers/launch_provider.dart';
import 'package:iitism_smartid_app/screens/landing.dart';
import 'package:iitism_smartid_app/screens/offline_page.dart';
import 'package:iitism_smartid_app/screens/splash.dart';
import 'package:iitism_smartid_app/utils/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => LaunchProvider.instance(),
        ),
        ChangeNotifierProvider(
          builder: (context) => AuthProvider.instance(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      textStyle: TextStyle(color: getPrimaryColor()),
      radius: 5,
      textPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      position: ToastPosition(align: Alignment.topCenter, offset: 80),
      dismissOtherOnShow: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'HindSiliguri',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          // '/login': (context) => LoginPage(),
          '/landing': (context) => Landing(),
          '/offline': (context) => OfflinePage(),
          // '/profile': (context) => Profile(),
        },
      ),
    );
  }
}
