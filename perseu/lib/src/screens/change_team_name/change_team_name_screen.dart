import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/utils/palette.dart';
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

  static const backgroundColor = Colors.white;
  static const foregroundColor = Palette.primary;

  static const standardStyle = TextStyle(color: foregroundColor, fontSize: 16);
  static const standardStyleBold = TextStyle(
      color: foregroundColor, fontSize: 16, fontWeight: FontWeight.bold);

  static const standardBorder = 4.0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ChangeTeamNameViewModel>(),
      child: Consumer<ChangeTeamNameViewModel>(
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(title: const Text('Nome da Equipe')),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: Palette.accent, width: 5)
                            )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Nome atual:',
                                    style: standardStyleBold),
                                const SizedBox(width: 4),
                                Text(model.oldTeamName, style: standardStyle)
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller,
                        onChanged: (value) => model.teamName = value,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(standardBorder))),
                          hintText: 'Informe o novo nome',
                          labelText: 'Novo nome',
                        ),
                        validator: RequiredValidator(
                            errorText: 'O novo nome precisa ser informado'),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(standardBorder))))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final result = await model.changeTeamName();
                              if (result.success) {
                                model.updateTeamSession();
                                UIHelper.showSuccess(context, result, pop: true);
                              } else {
                                UIHelper.showError(context, result);
                              }
                            }
                          },
                          child: const Text('Salvar'))
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
}
