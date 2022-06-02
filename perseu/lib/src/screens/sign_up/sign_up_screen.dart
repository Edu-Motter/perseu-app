import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatelessWidget {
  static const Key nameInputKey = Key('nameInput');
  static const Key birthdayInputKey = Key('birthdayInput');
  static const Key emailInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key confirmPasswordInputKey = Key('confirmPasswordInput');
  static const Key profileInputKey = Key('profileInput');

  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var userTypeName = 'Atleta';

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        leading: Consumer<SignUpViewModel>(builder: (_, model, child) {
          return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: model.isBusy ? Colors.black : Colors.white,
              ),
              onPressed: () {
                if (model.isBusy) return;
                Navigator.of(context).pushReplacementNamed(Routes.login);
              });
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
                              errorText: 'O usuário precisa ser informado'),
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
                    const SizedBox(
                      height: 16.0,
                    ),
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
  }
}
