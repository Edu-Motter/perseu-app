import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../app/routes.dart';
import '../../services/foundation.dart';
import '../../utils/ui.dart';
import 'athlete_request_viewmodel.dart';

class AthleteRequestScreen extends StatefulWidget {
  const AthleteRequestScreen({Key? key}) : super(key: key);

  @override
  State<AthleteRequestScreen> createState() => _AthleteRequestScreenState();
}

class _AthleteRequestScreenState extends State<AthleteRequestScreen> {
  final TextEditingController _requestCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AthleteRequestViewModel>(),
      child: Consumer<AthleteRequestViewModel>(
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
              backgroundColor: Palette.background,
              key: scaffoldKey,
              drawer: const UserDrawer(),
              appBar: AppBar(
                title: const Text('Ingressar na Equipe'),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    if(scaffoldKey.currentState != null){
                      scaffoldKey.currentState!.openDrawer();
                    }
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Image.asset('assets/images/dumbbell-accent.png',
                              width: 160.0),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              '${model.athleteName}, informe o código da equipe: ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Palette.primary, fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _requestCodeController,
                              onChanged: (value) => model.requestCode = value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Código da equipe',
                                labelText: 'Código',
                              ),
                              validator: RequiredValidator(
                                  errorText: 'O código precisa ser informado'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () async {
                            await handleSend(model, context);
                          },
                          child: const Text('Enviar'))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> handleSend(
      AthleteRequestViewModel model, BuildContext context) async {
    final navigator = Navigator.of(context);
    if (_formKey.currentState!.validate()) {
      final Result result = await model.createRequest();
      if (result.success) {
        navigator.pushNamedAndRemoveUntil(
            Routes.athletePendingRequest, (route) => false);
        UIHelper.showSuccess(context, result);
      } else {
        UIHelper.showError(context, result);
      }
    }
  }
}
