import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/dtos/status.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';
import 'package:provider/provider.dart';

import '../app/locator.dart';
import '../services/foundation.dart';
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
    Color themeColor = Palette.secondary;
    return ChangeNotifierProvider(
      create: (_) => locator<LoginViewModel>(),
      child: Consumer<LoginViewModel>(
        builder: (context, loginModel, child) {
          return ModalProgressHUD(
            inAsyncCall: loginModel.isBusy,
            child: Scaffold(
                backgroundColor: Palette.background,
                appBar: AppBar(
                  title: const Text('Perseu'),
                ),
                body: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Image.asset(LoginViewModel.image, height: 160,),
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
                                      'Olá! Realize seu login:',
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
                                style: const TextStyle(color: Palette.primary),
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  hintText: 'E-mail',
                                ),
                                validator: RequiredValidator(
                                    errorText: 'O usuário precisa ser informado'),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                key: LoginScreen.passwordInputKey,
                                controller: _passwordController,
                                onChanged: (value) => loginModel.password = value,
                                style: const TextStyle(color: Palette.primary),
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Senha',
                                ),
                                validator: RequiredValidator(
                                    errorText: 'A senha precisa ser informada'),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Palette.accent)),
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
                                                  color: Palette.secondary))),
                                      child: const Text(
                                        'Não possuo conta ainda',
                                        style: TextStyle(fontSize: 16, color: Palette.secondary),
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
        final loginDto = result.data!;
        _handleUserNavigation(context, loginDto.status);
      } else {
        UIHelper.showError(context, result);
      }
    }
  }

  _handleUserNavigation(BuildContext context, Status statusLogin){
    switch (statusLogin) {
      case Status.athleteWithTeam:
        Navigator.pushReplacementNamed(context, Routes.athleteHome);
        break;
      case Status.athleteWithoutTeam:
        Navigator.pushReplacementNamed(context, Routes.athleteRequest);
        break;
      case Status.athleteWithPendingTeam:
        Navigator.pushReplacementNamed(context, Routes.athletePendingRequest);
        break;
      case Status.coachWithTeam:
        Navigator.pushReplacementNamed(context, Routes.coachHome);
        break;
      case Status.coachWithoutTeam:
        Navigator.pushReplacementNamed(context, Routes.newTeam);
        break;
      default:
        UIHelper.showError(context, const Result.error(message: 'Rota não encontrada'));
    }
  }
}