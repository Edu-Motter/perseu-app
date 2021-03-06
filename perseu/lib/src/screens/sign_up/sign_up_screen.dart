import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/dialogs/email_already_exists_dialog.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:perseu/src/utils/validators.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import 'package:perseu/src/components/dialogs/passwords_not_match_dialog.dart';
import '../../services/foundation.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static const Key nameInputKey = Key('nameInput');
  static const Key birthdayInputKey = Key('birthdayInput');
  static const Key emailInputKey = Key('emailInput');
  static const Key cpfInputKey = Key('cpfInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key confirmPasswordInputKey = Key('confirmPasswordInput');
  static const Key profileInputKey = Key('profileInput');
  static const Key crefInputKey = Key('crefInput');
  static const Key heightInputKey = Key('heightInput');
  static const Key weightInputKey = Key('weightInput');

  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _crefController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final List<String> _userTypes = ['Atleta', 'Treinador'];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<SignUpViewModel>(),
      child: Consumer<SignUpViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Cadastro'),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: model.isBusy ? Colors.grey : Colors.white,
                  ),
                  onPressed: () {
                    if (model.isBusy) return;
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  }),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.person_add,
                          size: 32,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        'Informe os seguintes dados:',
                        style: TextStyle(color: Colors.teal, fontSize: 18),
                      ),
                      SizedBox(height: 8)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Consumer<SignUpViewModel>(
                      builder: (_, model, child) {
                        return Column(children: [
                          TextFormField(
                            key: SignUpScreen.nameInputKey,
                            controller: _nameController,
                            onChanged: (value) => model.name = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Nome:',
                            ),
                            validator: RequiredValidator(
                                errorText: 'O Nome precisa ser informado'),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.emailInputKey,
                            controller: _emailController,
                            onChanged: (value) => model.email = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'E-mail:',
                            ),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'O E-mail precisa ser informado'),
                              EmailValidator(
                                  errorText: 'O E-mail precisa ser v??lido')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.cpfInputKey,
                            controller: _cpfController,
                            onChanged: (value) => model.cpf = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'CPF:',
                            ),
                            inputFormatters: [Formatters.cpf()],
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'O CPF precisa ser informado'),
                              CpfValidator(
                                  errorText: 'O CPF precisa ser v??lido')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                              key: SignUpScreen.birthdayInputKey,
                              controller: _birthdayController,
                              onChanged: (value) => model.birthday = value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Data de nascimento:',
                              ),
                              inputFormatters: [Formatters.date()],
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText:
                                        'O usu??rio precisa ser informado'),
                                DateValidator('dd/MM/yyyy',
                                    errorText: 'A data precisa ser v??lida')
                              ])),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.passwordInputKey,
                            controller: _passwordController,
                            onChanged: (value) => model.password = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Senha',
                            ),
                            obscureText: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'A senha precisa ser informada'),
                              MinLengthValidator(4, errorText: 'A senha precisa ser no m??nimo 4 caracteres')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.confirmPasswordInputKey,
                            controller: _confirmPasswordController,
                            onChanged: (value) => model.confirmPassword = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Confirma????o da senha:',
                            ),
                            obscureText: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Voc?? precisa confirmar sua senha'),
                              MinLengthValidator(4, errorText: 'A senha precisa ser no m??nimo 4 caracteres')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField(
                              items: getDropDownMenuItems(),
                              value: model.userType,
                              onChanged: (value) {
                                model.userTypeValue(value as String);
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              )),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: model.isCoach,
                            child: TextFormField(
                              key: SignUpScreen.crefInputKey,
                              controller: _crefController,
                              onChanged: (value) => model.cref = value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'CREF:',
                              ),
                              validator: RequiredValidator(
                                  errorText: 'O CREF precisa ser informado'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: model.isAthlete,
                            child: TextFormField(
                              key: SignUpScreen.heightInputKey,
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) => model.height = value,
                              inputFormatters: [Formatters.height()],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Altura: 0.00 m',
                              ),
                              validator: RequiredValidator(
                                  errorText: 'A Altura precisa ser informada'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Visibility(
                            visible: model.isAthlete,
                            child: TextFormField(
                              key: SignUpScreen.weightInputKey,
                              controller: _weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) => model.weight = value,
                              inputFormatters: [Formatters.weight()],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Peso: 00 Kg',
                              ),
                              validator: RequiredValidator(
                                  errorText: 'O Peso precisa ser informado'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                              onPressed: model.isBusy
                                  ? null
                                  : () => _handleSignUp(context, model),
                              child: child),
                        ]);
                      },
                      child: const Text('Criar conta'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _handleSignUp(BuildContext context, SignUpViewModel model) async {
    if (_formKey.currentState!.validate()) {
      if(_passwordsValidation(model)){
        showDialog(
            context: context,
            builder: (context) => const PasswordsNotMatchDialog());
        return;
      }

      if(await _emailValidation(model)){
        showDialog(
            context: context,
            builder: (context) => const EmailAlreadyExists());
        return;
      }

      Result result = await model.signUp();
      if (result.success) {
        UIHelper.showSuccessWithRoute(context, result,
                () => Navigator.of(context).pushReplacementNamed(Routes.login));
      } else {
        UIHelper.showError(context, result);
      }
    }
  }

  Future<bool> _emailValidation(SignUpViewModel model) async {
     final result = await model.checkEmail(model.email);
     return !result.success;
  }

  bool _passwordsValidation(SignUpViewModel model) {
    return model.password != model.confirmPassword;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String type in _userTypes) {
      items.add(DropdownMenuItem(value: type, child: Text('Conta $type')));
    }
    return items;
  }
}
