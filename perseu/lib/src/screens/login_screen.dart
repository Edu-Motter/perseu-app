// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/viewModels/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final String? title;

  static const Key usernameInputKey = Key('emailInput');
  static const Key passwordInputKey = Key('passwordInput');
  static const Key submitButtonKey = Key('submitButton');
  static const userType = 'coach';
  static const teamId = '14';

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Color themeColor = Colors.teal;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login'),
          bottom: const LoadingLinear(),
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
                  child:
                      Consumer<LoginViewModel>(builder: (_, loginModel, child) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Seja bem vindo, realize seu login:',
                                style: TextStyle(
                                    color: themeColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TextFormField(
                          key: LoginScreen.usernameInputKey,
                          controller: _usernameController,
                          onChanged: (value) => loginModel.setUsername = value,
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
                          onChanged: (value) => loginModel.setPassword = value,
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
                                : () async {
                                    final valor2 = LoginViewModel();
                                    valor2.login();
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.of(context)
                                          .pushNamed(userType == 'athlete'
                                              ? teamId != null
                                                  ? Routes.athleteHome
                                                  : Routes.athleteEnterTeam
                                              : teamId != null
                                                  ? Routes.coachHome
                                                  : Routes.coachCreatesTeam);
                                    }
                                  },
                            child: const Text('Entrar',
                                style: TextStyle(fontSize: 16))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              debugPrint('isBusy: ${loginModel.isBusy}');
                              if (loginModel.isNotBusy) {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.signUp);
                              }
                            },
                            child: Container(
                                padding: const EdgeInsets.only(bottom: 1),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2.0, color: Colors.black))),
                                child: const Text(
                                  'Não possuo conta ainda',
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                        ),
                      ],
                    );
                  })),
            )
          ],
        ));
  }
}

const double _kMyLinearProgressIndicatorHeight = 6.0;

class MyLinearProgressIndicator extends LinearProgressIndicator {
  const MyLinearProgressIndicator({
    Key? key,
    double? value,
    Color? backgroundColor,
    Animation<Color>? valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        );
}

class LoadingLinear extends StatelessWidget implements PreferredSizeWidget {
  const LoadingLinear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = context.watch<LoginViewModel>();

    if (loginController.isNotBusy) return const SizedBox();

    return const MyLinearProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70));
  }

  @override
  Size get preferredSize =>
      const Size(double.infinity, _kMyLinearProgressIndicatorHeight);
}
