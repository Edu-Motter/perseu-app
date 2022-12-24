import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/states/style.dart';

class PasswordsNotMatchDialog extends StatelessWidget {
  final String message;

  const PasswordsNotMatchDialog(
      {Key? key,
      this.message = 'Verifique suas senhas, pois elas não são iguais'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = locator<Style>();

    return AlertDialog(
      title: const Text('Senhas diferentes'),
      content: Text(message),
      actions: [
        ElevatedButton(
            style: style.buttonAlertPrimary,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );
  }
}
