import 'package:flutter/material.dart';
import 'package:perseu/src/utils/trigger.dart';
import 'package:perseu/src/viewModels/bootstrap_view_model.dart';
import 'package:provider/provider.dart';

import '../app/locator.dart';
import '../app/routes.dart';
import '../services/foundation.dart';

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
    LoadSessionResult result = await model.loadSession();
    if(LoadSessionResult.successAthlete == result){
      Navigator.of(context).pushReplacementNamed(Routes.athleteHome);
    } else if (LoadSessionResult.successCoach == result) {
      Navigator.of(context).pushReplacementNamed(Routes.coachHome);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}
