import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/screens/new_team/new_team_viewmodel.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class NewTeamScreen extends StatefulWidget {
  const NewTeamScreen({Key? key}) : super(key: key);

  @override
  State<NewTeamScreen> createState() => _NewTeamScreenState();
}

class _NewTeamScreenState extends State<NewTeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<NewTeamViewModel>(),
      child: Consumer<NewTeamViewModel>(
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, Routes.login)),
                title: const Text('Criando Equipe'),
              ),
              body: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset('assets/images/fitness-1.png',
                            width: 180.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Bem vindo ao app Perseu, treinador ${model.session.user?.name}'
                            ', para iniciar informe o nome da sua equipe: ',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _teamNameController,
                            onChanged: (value) => model.teamName = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Informe o nome da sua equipe:',
                              labelText: 'Nome da equipe:',
                            ),
                            validator: RequiredValidator(
                                errorText: 'O nome precisa ser informado'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final Result result = await model.createTeam();
                                if (result.success) {
                                  UIHelper.showSuccessWithRoute(
                                      context,
                                      result,
                                      () => Navigator.of(context)
                                          .pushReplacementNamed(
                                              Routes.coachHome));
                                } else {
                                  UIHelper.showError(context, result);
                                }
                              }
                            },
                            child: const Text('Cadastrar'))
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
