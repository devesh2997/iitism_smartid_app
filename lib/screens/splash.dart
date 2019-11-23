import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:iitism_smartid_app/providers/connectivity_provider.dart';
import 'package:iitism_smartid_app/providers/launch_provider.dart';
import 'package:iitism_smartid_app/widgets/with_authentication.dart';
import 'package:provider/provider.dart';

import 'landing.dart';
import 'launch_page.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ConnectivityProvider.instance(context),
      child: Consumer<LaunchProvider>(
        builder: (context, LaunchProvider launch, _) {
          switch (launch.status) {
            case LaunchStatus.Loading:
              return SplashView();
            case LaunchStatus.Ready:
              return WithAuthentication(
                child: Landing(),
              );
            case LaunchStatus.FirstLaunch:
              return Launch();
            default:
              return SplashView();
          }
        },
      ),
    );
  }
}

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SizedBox(
            height: 200,
            child: FlareActor(
              'assets/flares/pulsing.flr',
              animation: "stand_by",
            ),
          ),
        ),
      ),
    );
  }
}
