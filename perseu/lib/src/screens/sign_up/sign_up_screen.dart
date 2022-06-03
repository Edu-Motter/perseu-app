import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static const Key nameInputKey = Key('nameInput');
  static const Key birthdayInputKey = Key('birthdayInput');
  static const Key emailInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key confirmPasswordInputKey = Key('confirmPasswordInput');
  static const Key profileInputKey = Key('profileInput');
  static const Key crefInputKey = Key('crefInput');

  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _crefController = TextEditingController();

  final List<String> _userTypes = ['Atleta', 'Treinador'];

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
                    color: model.isBusy ? Colors.black : Colors.white,
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
                                errorText: 'O usuário precisa ser informado'),
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
                            validator: RequiredValidator(
                                errorText: 'O usuário precisa ser informado'),
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
                                        'O usuário precisa ser informado'),
                                DateValidator('dd/MM/yyyy',
                                    errorText: 'A data precisa ser válida')
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
                            validator: RequiredValidator(
                                errorText: 'O usuário precisa ser informado'),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.confirmPasswordInputKey,
                            controller: _confirmPasswordController,
                            onChanged: (value) => model.confirmPassword = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Confirmação da senha:',
                            ),
                            validator: RequiredValidator(
                                errorText: 'O usuário precisa ser informado'),
                          ),
                          const SizedBox(height: 8),
                          // const Text(
                          //   'Escolha seu tipo de usuário:',
                          //   style: TextStyle(color: Colors.teal),
                          // ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField(
                              items: getDropDownMenuItems(),
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
                          ElevatedButton(
                              onPressed: model.isBusy ? null : model.signUp,
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

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String type in _userTypes) {
      items.add(DropdownMenuItem(value: type, child: Text('Conta $type')));
    }
    return items;
  }
}
