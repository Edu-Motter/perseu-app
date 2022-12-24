import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/dialogs/passwords_not_match_dialog.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/sign_up/sign_up_viewmodel.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/palette.dart';

import 'package:perseu/src/utils/ui.dart';
import 'package:perseu/src/utils/validators.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';
import '../../services/foundation.dart';

class SignUpScreen extends StatefulWidget {
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

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  static const fillColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<SignUpViewModel>(),
      child: Consumer<SignUpViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Cadastro'),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: model.isBusy ? Colors.grey : Palette.background,
                  ),
                  onPressed: () {
                    if (model.isBusy) return;
                    Navigator.of(context).pushReplacementNamed(Routes.login);
                  }),
            ),
            body: ListView(
              children: [
                const ListTitle(
                  text: 'Informe os seguintes dados:',
                  dividerPadding: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'Nome',
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
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'E-mail',
                            ),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'O E-mail precisa ser informado'),
                              EmailValidator(
                                  errorText: 'O E-mail precisa ser válido')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.cpfInputKey,
                            controller: _cpfController,
                            onChanged: (value) => model.cpf = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'CPF',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [Formatters.cpf()],
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'O CPF precisa ser informado'),
                              CpfValidator(
                                  errorText: 'O CPF precisa ser válido')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                              key: SignUpScreen.birthdayInputKey,
                              controller: _birthdayController,
                              onChanged: (value) => model.birthdate = value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: fillColor,
                                hintText: 'Data de nascimento',
                              ),
                              keyboardType: TextInputType.number,
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
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'Senha',
                            ),
                            obscureText: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'A senha precisa ser informada'),
                              MinLengthValidator(4,
                                  errorText:
                                      'A senha precisa ser no mínimo 4 caracteres')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            key: SignUpScreen.confirmPasswordInputKey,
                            controller: _confirmPasswordController,
                            onChanged: (value) => model.confirmPassword = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: fillColor,
                              hintText: 'Confirmação da senha:',
                            ),
                            obscureText: true,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText:
                                      'Você precisa confirmar sua senha'),
                              MinLengthValidator(4,
                                  errorText:
                                      'A senha precisa ser no mínimo 4 caracteres')
                            ]),
                          ),
                          const SizedBox(height: 8),
                          const AccentDivider(dividerPadding: 0),
                          const SizedBox(height: 8),
                          DropdownButtonFormField(
                              validator: RequiredValidator(
                                  errorText:
                                      'Você precisa escolher seu tipo de conta'),
                              items: getDropDownMenuItems(),
                              value: model.userType,
                              onChanged: (value) {
                                model.userTypeValue(value as String);
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: fillColor,
                                border: OutlineInputBorder(),
                              )),
                          Visibility(
                            visible: model.isCoach,
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                TextFormField(
                                  key: SignUpScreen.crefInputKey,
                                  controller: _crefController,
                                  onChanged: (value) => model.cref = value,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: fillColor,
                                    hintText: 'CREF',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  inputFormatters: [Formatters.cref()],
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            'Você precisa confirmar seu CREF'),
                                    MinLengthValidator(11,
                                        errorText:
                                            'O CREF precisa ter 11 caracteres')
                                  ]),
                                ),
                              ],
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
                                filled: true,
                                fillColor: fillColor,
                                hintText: 'Altura 0.00 m',
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
                              keyboardType: TextInputType.number,
                              onChanged: (value) => _formatWeight(value, model),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: fillColor,
                                hintText: 'Peso 00 Kg',
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
      if (_passwordsValidation(model)) {
        showDialog(
            context: context,
            builder: (context) => const PasswordsNotMatchDialog());
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

  bool _passwordsValidation(SignUpViewModel model) {
    return model.password != model.confirmPassword;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String type in _userTypes) {
      items.add(DropdownMenuItem(value: type, child: Text('Conta $type')));
    }
    items.add(const DropdownMenuItem(value: '', child: Text('Tipo de conta')));
    return items;
  }

  _formatWeight(String value, SignUpViewModel model) {
    if (value.length > 6) {
      _weightController.text = value.substring(0, 6);
      return;
    }

    String numberValue = '';
    if (value.length > 5) {
      numberValue = value.replaceAll(' Kg', '');
    }

    if (value.length < model.weight.length && value.length > 2) {
      setState(() {
        _weightController.text = '';
      });
    }

    if (value.length == 2) {
      setState(() {
        _weightController.text = '$value Kg';
      });
    }

    if (numberValue.length == 3) {
      setState(() {
        _weightController.text = '$numberValue Kg';
      });
    }

    model.weight = value;
    _weightController.selection = TextSelection.fromPosition(
        TextPosition(offset: _weightController.text.length));
  }
}
