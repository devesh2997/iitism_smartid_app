import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LaunchStatus { Loading, FirstLaunch, Ready }

class LaunchProvider extends ChangeNotifier {
  LaunchStatus status;

  LaunchProvider.instance() : status = LaunchStatus.Loading {
    _checkForFirstLaunch();
  }

  _checkForFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getBool('is_first_launch') ?? false
        ? LaunchStatus.FirstLaunch
        : LaunchStatus.Ready;
    notifyListeners();
  }

  void introDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('is_first_launch', false);
    status = LaunchStatus.Ready;
    notifyListeners();
  }
}
