import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/viewModels/sign_up_view_model.dart';
import 'package:provider/provider.dart';

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
        leading:
            Consumer<SignUpViewModel>(builder: (_, signUpController, child) {
          return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: signUpController.isBusy ? Colors.black : Colors.white,
              ),
              onPressed: () {
                if (signUpController.isBusy) return;
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
                builder: (_, signUpController, child) {
                  return Column(children: [
                    TextFormField(
                      key: SignUpScreen.nameInputKey,
                      controller: _nameController,
                      onChanged: (value) => signUpController.setName = value,
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
                      onChanged: (value) => signUpController.setEmail = value,
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
                      onChanged: (value) =>
                          signUpController.setBirthday = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Data de nascimento:',
                      ),
                      validator: RequiredValidator(
                          errorText: 'O usuário precisa ser informado'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: SignUpScreen.passwordInputKey,
                      controller: _passwordController,
                      onChanged: (value) =>
                          signUpController.setPassword = value,
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
                      onChanged: (value) =>
                          signUpController.setConfirmPassword = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Confirmação da senha:',
                      ),
                      validator: RequiredValidator(
                          errorText: 'O usuário precisa ser informado'),
                    ),
                    const SizedBox(height: 8),
                    Consumer<SignUpViewModel>(
                        builder: (context, signUpController, child) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                                value: signUpController.userType,
                                onChanged: (value) {
                                  signUpController.setUserType = value;
                                  userTypeName = value ? 'Atleta' : 'Treinador';
                                }),
                            Text(userTypeName)
                          ]);
                    }),
                    const SizedBox(
                      height: 16.0,
                    ),
                    ElevatedButton(
                        onPressed: signUpController.isNotBusy
                            ? signUpController.signUp
                            : null,
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
