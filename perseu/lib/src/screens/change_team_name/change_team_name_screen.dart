import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import 'change_team_name_viewmodel.dart';

class ChangeTeamNameScreen extends StatefulWidget {
  const ChangeTeamNameScreen({Key? key}) : super(key: key);

  @override
  State<ChangeTeamNameScreen> createState() => _ChangeTeamNameScreenState();
}

class _ChangeTeamNameScreenState extends State<ChangeTeamNameScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ChangeTeamNameViewModel>(),
      child: Consumer<ChangeTeamNameViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Alterando Nome da Equipe')),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      onChanged: (value) => model.teamName = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Informe o novo nome:',
                        labelText: 'Novo nome:',
                      ),
                      validator: RequiredValidator(
                          errorText: 'O novo nome precisa ser informado'),
                    ),
                    const SizedBox(height: 16,),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final result = await model.changeTeamName();
                            if(result.success){
                              UIHelper.showSuccess(context, result);
                            } else {
                              UIHelper.showError(context, result);
                            }
                          }
                        },
                        child: const Text('Salvar alteração'))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
