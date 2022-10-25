import 'package:flutter/material.dart';
import 'package:perseu/src/screens/athlete_pending_request/athlete_pending_request_viewmodel.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../app/routes.dart';

class AthletePendingRequestScreen extends StatelessWidget {
  AthletePendingRequestScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<AthletePendingRequestViewModel>(),
        child: Consumer<AthletePendingRequestViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              drawer: const UserDrawer(),
              appBar: AppBar(
                title: const Text('Solicitação pendente'),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset('assets/images/fitness-1.png', width: 160.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Sua solicitação de ingresso na equipe encontra-se'
                          ' pendente ainda. O treinador é responsável por aceitá-la',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () => _handleCheckRequest(context, model),
                          child: const Text('Verificar novamente')),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () => _handleCancelRequest(context, model),
                          child: const Text('Cancelar solicitação')),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  _handleCheckRequest(
    BuildContext context,
    AthletePendingRequestViewModel model,
  ) async {
    final Result result = await model.checkRequestStatus();
    if (result.success) {
      UIHelper.showSuccess(context, result);
    } else {
      UIHelper.showError(context, result);
    }
  }

  _handleCancelRequest(
    BuildContext context,
    AthletePendingRequestViewModel model,
  ) async {
    final navigator = Navigator.of(context);
    final Result result = await model.cancelRequest();
    if (result.success) {
      navigator.pushNamedAndRemoveUntil(
          Routes.athleteRequest, (route) => false);
      UIHelper.showSuccess(context, result);
    } else {
      UIHelper.showError(context, result);
    }
  }
}
