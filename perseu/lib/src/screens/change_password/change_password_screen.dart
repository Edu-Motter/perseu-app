import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/components/dialogs/passwords_not_match_dialog.dart';
import 'package:perseu/src/screens/change_password/change_password_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../app/locator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<ChangePasswordViewModel>(),
        child: Consumer<ChangePasswordViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Palette.background,
              appBar: AppBar(
                title: const Text('Alterar senha'),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          onChanged: (value) => model.password = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Informe sua senha atual',
                            labelText: 'Senha atual',
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                    'A senha atual precisa ser informada'),
                            MinLengthValidator(4,
                                errorText:
                                    'A senha precisa ter no mínimo 4 caracteres')
                          ]),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _newPasswordController,
                          onChanged: (value) => model.newPassword = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Informe sua nova senha',
                            labelText: 'Nova senha',
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText:
                                    'A nova senha precisa ser informada'),
                            MinLengthValidator(4,
                                errorText:
                                    'A senha precisa ter no mínimo 4 caracteres')
                          ]),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmNewPasswordController,
                          onChanged: (value) =>
                              model.confirmNewPassword = value,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirme sua nova nova senha',
                            labelText: 'Confirme nova senha',
                          ),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Você precisa confirmar a senha'),
                            MinLengthValidator(4,
                                errorText:
                                    'A senha precisa ter no mínimo 4 caracteres')
                          ]),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: model.isBusy
                                ? null
                                : () => _handleSave(model, context),
                            child: const Text('Salvar'))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  _handleSave(ChangePasswordViewModel model, BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_blancValidation()) {
      UIHelper.showError(
          context, const Result.error(message: 'Informe senhas válidas'));
      return;
    }

    if (_passwordsValidation(model)) {
      final result = await model.changePassword();
      if (result.success) {
        Navigator.of(context).pop();
        UIHelper.showSuccess(context, result);
        return;
      }
      UIHelper.showError(context, result);
    } else {
      showDialog(
          context: context,
          builder: (context) => const PasswordsNotMatchDialog(
                message:
                    'Verifique suas novas senhas, pois elas não são iguais',
              ));
    }
  }

  bool _blancValidation() {
    if (_passwordController.text.trim().isEmpty) return true;
    if (_confirmNewPasswordController.text.trim().isEmpty) return true;
    if (_newPasswordController.text.trim().isEmpty) return true;

    return false;
  }

  bool _passwordsValidation(ChangePasswordViewModel model) {
    return model.newPassword == model.confirmNewPassword;
  }
}
