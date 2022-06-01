// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';
import 'package:provider/provider.dart';

import '../app/locator.dart';
import '../models/user_model.dart';
import '../utils/ui.dart';

class LoginScreen extends StatelessWidget {
  final String? title;

  static const Key usernameInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key submitButtonKey = Key('submitButton');
  static const userType = 'coach';
  static const teamId = '14';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;
    return ChangeNotifierProvider(
      create: (_) => locator<LoginViewModel>(),
      child: Consumer<LoginViewModel>(
        builder: (context, loginModel, child) {
          return ModalProgressHUD(
            inAsyncCall: loginModel.isBusy,
            child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text('Login'),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 94.0),
                      child: Image.asset(LoginViewModel.gif),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                      'Seja bem vindo, realize seu login:',
                                      style: TextStyle(
                                          color: themeColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              TextFormField(
                                key: LoginScreen.usernameInputKey,
                                controller: _usernameController,
                                onChanged: (value) => loginModel.username = value,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Informe seu usuário',
                                ),
                                validator: RequiredValidator(
                                    errorText: 'O usuário precisa ser informado'),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                key: LoginScreen.passwordInputKey,
                                controller: _passwordController,
                                onChanged: (value) => loginModel.password = value,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Informe sua senha',
                                ),
                                validator: RequiredValidator(
                                    errorText: 'A senha precisa ser informada'),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(themeColor)),
                                  onPressed: loginModel.isBusy
                                      ? null
                                      : () {
                                          _login(loginModel, context);
                                        },
                                  child: const Text('Entrar',
                                      style: TextStyle(fontSize: 16))),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.signUp);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.only(bottom: 1),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.black))),
                                      child: const Text(
                                        'Não possuo conta ainda',
                                        style: TextStyle(fontSize: 16),
                                      )),
                                ),
                              ),
                            ],
                          )),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  void _login(LoginViewModel loginModel, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final result = await loginModel.login();
      if (result.success) {
        //Do more login things:
        //UserModel user = result.data!;
        if ('Atleta' == result.data!.user.name) {
          Navigator.pushReplacementNamed(context, Routes.athleteHome);
        } else {
          Navigator.pushReplacementNamed(context, Routes.coachHome);
        }
      } else {
        UIHelper.showError(context, result);
      }
    }
  }
}