import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:perseu/src/screens/change_password/change_password_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<ChangePasswordViewModel>(),
        child: Consumer<ChangePasswordViewModel>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Alterando senha'),
              ),
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        onChanged: (value) => model.password = value,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Informe sua senha atual',
                          labelText: 'Senha atual',
                        ),
                        validator: RequiredValidator(
                            errorText: 'A senha atual precisa ser informada'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPasswordController,
                        onChanged: (value) => model.newPassword = value,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Informe sua nova senha',
                          labelText: 'Nova senha',
                        ),
                        validator: RequiredValidator(
                            errorText: 'A nova senha precisa ser informada'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmNewPasswordController,
                        onChanged: (value) => model.confirmNewPassword = value,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Confirme sua nova nova senha',
                          labelText: 'Confirme nova senha',
                        ),
                        validator: RequiredValidator(
                            errorText: 'Precisa confirmar sua nova senha'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed:
                              model.isBusy ? null : () => _handleSave(model),
                          child: const Text('Salvar'))
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  _handleSave(ChangePasswordViewModel model) {}
}
