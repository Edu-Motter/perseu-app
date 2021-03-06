import 'package:flutter/material.dart';
import 'package:perseu/src/screens/athlete_pending_request/athlete_pending_request_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../app/routes.dart';

class AthletePendingRequestScreen extends StatelessWidget {
  const AthletePendingRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<AthletePendingRequestViewModel>(),
        child: Consumer<AthletePendingRequestViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, Routes.login)),
                title: const Text('Solicitação pendente'),
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
                          'Sua solicitação de ingresso na equipe:  encontra-se'
                          ' pendente ainda. O treinador é responsável por aceitá-la',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            model.checkRequestStatus();
                          },
                          child: const Text('Verificar novamente')),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            model.cancelRequest();
                          },
                          child: const Text('Cancelar solicitação'))
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
