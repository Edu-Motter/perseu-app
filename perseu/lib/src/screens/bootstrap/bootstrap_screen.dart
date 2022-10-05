import 'package:flutter/material.dart';
import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/screens/bootstrap/bootstrap_viewmodel.dart';
import 'package:perseu/src/utils/trigger.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../app/routes.dart';

class BootstrapScreen extends StatelessWidget {
  const BootstrapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<BootstrapViewModel>(),
      child: Consumer<BootstrapViewModel>(
        builder: ((context, model, _) {
          return Trigger(
            onCreate: () {
              _loadSession(model, context);
            },
            child: Container(
              color: Colors.teal,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wb_cloudy,
                      size: 86,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        visible: model.isBusy)
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _loadSession(BootstrapViewModel model, BuildContext context) async {
    Status result = await model.loadSession();
    _handleUserNavigation(context, result);
  }

  _handleUserNavigation(BuildContext context, Status statusLogin){
    switch (statusLogin) {
      case Status.athleteWithTeam:
        Navigator.pushReplacementNamed(context, Routes.athleteHome);
        break;
      case Status.athleteWithoutTeam:
        Navigator.pushReplacementNamed(context, Routes.athleteRequest);
        break;
      case Status.athleteWithPendingTeam:
        Navigator.pushReplacementNamed(context, Routes.athletePendingRequest);
        break;
      case Status.coachWithTeam:
        Navigator.pushReplacementNamed(context, Routes.coachHome);
        break;
      case Status.coachWithoutTeam:
        Navigator.pushReplacementNamed(context, Routes.newTeam);
        break;
      default:
        Navigator.pushReplacementNamed(context, Routes.login);
    }
  }
}
