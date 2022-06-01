import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/screens/profile_screen/profile_viewmodel.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:perseu/src/utils/validators.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../app/routes.dart';
import '../../states/session.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const Key nameInputKey = Key('nameInput');
  static const Key birthdayInputKey = Key('birthdayInput');
  static const Key cpfInputKey = Key('cpfInputKey');
  static const Key emailInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key confirmPasswordInputKey = Key('confirmPasswordInput');
  static const Key profileInputKey = Key('profileInput');

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final session = locator<Session>();
    _nameController.text = session.user!.name;
    _emailController.text = session.user!.email;
    _cpfController.text = Formatters.cpfFormatter(session.user!.cpf);
    _birthdayController.text = Formatters.dateFormatter(session.user!.bornOn);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ProfileViewModel>(),
      child: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          return ModalProgressHUD(
              inAsyncCall: model.isBusy,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Perfil'),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              key: ProfileScreen.nameInputKey,
                              controller: _nameController,
                              onChanged: (value) => model.name = value,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Nome:',
                                  labelText: 'Nome:'),
                              validator: RequiredValidator(
                                  errorText:
                                      'O nome de usuário precisa ser informado'),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                                key: ProfileScreen.emailInputKey,
                                controller: _emailController,
                                onChanged: (value) => model.email = value,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'E-mail:',
                                    labelText: 'E-mail:'),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText:
                                          'O E-mail precisa ser informado'),
                                  EmailValidator(
                                      errorText: 'O E-mail precisa ser válido')
                                ])),
                            const SizedBox(height: 16),
                            TextFormField(
                                key: ProfileScreen.cpfInputKey,
                                controller: _cpfController,
                                onChanged: (value) => model.cpf = value,
                                inputFormatters: [Formatters.cpf()],
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'CPF:',
                                    labelText: 'CPF:'),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'O CPF precisa ser informado'),
                                  CpfValidator(
                                      errorText: 'O CPF precisa ser válido')
                                ])),
                            const SizedBox(height: 16),
                            TextFormField(
                                key: ProfileScreen.birthdayInputKey,
                                controller: _birthdayController,
                                onChanged: (value) => model.birthday = value,
                                inputFormatters: [Formatters.date()],
                                keyboardType: TextInputType.datetime,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Data de nascimento:',
                                    labelText: 'Data de nascimento:'),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText:
                                          'A data de nascimento precisa ser informada'),
                                  DateValidator('dd/MM/yyyy',
                                      errorText: 'A data precisa ser válida')
                                ])),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: model.isBusy
                                    ? null
                                    : ()  => Navigator.of(context).pushNamed(Routes.changePassword),
                                child: const Text('Alterar senha')),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: model.isBusy
                                    ? null
                                    : ()  => _handleSave(model),
                                child: const Text('Salvar')),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }

  void _handleSave(ProfileViewModel model) async {
    if(_formKey.currentState == null) return;
    if(_formKey.currentState!.validate()){
      final result = await model.save();
      if(result.success){
        UIHelper.showSuccess(context, result);
      }
    }
  }
}
