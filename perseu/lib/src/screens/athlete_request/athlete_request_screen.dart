import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/screens/new_team/new_team_viewmodel.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';
import 'athlete_request_viewmodel.dart';

class AthleteRequestScreen extends StatefulWidget {
  const AthleteRequestScreen({Key? key}) : super(key: key);

  @override
  State<AthleteRequestScreen> createState() => _AthleteRequestScreenState();
}

class _AthleteRequestScreenState extends State<AthleteRequestScreen> {
  final TextEditingController _requestCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AthleteRequestViewModel>(),
      child: Consumer<AthleteRequestViewModel>(
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Ingressando na Equipe'),
              ),
              body: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset('assets/images/fitness-1.png', width: 160.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Bem vindo ao Perseu, atleta ${model.session.user?.name}'
                                ', para iniciar informe o código da equipe: ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Form(
                          child: TextFormField(
                            controller: _requestCodeController,
                            onChanged: (value) => model.requestCode = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Informe o código da sua equipe:',
                              labelText: 'Código:',
                            ),
                            validator: RequiredValidator(
                                errorText: 'O código precisa ser informado'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () async {
                              // final Result result = await model.createRequest();
                              // if (result.success) {
                              //   UIHelper.showSuccessWithRoute(context, result,
                              //           () => Navigator.of(context).pop());
                              // } else {
                              //   UIHelper.showError(context, result);
                              // }
                            },
                            child: const Text('Enviar'))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
