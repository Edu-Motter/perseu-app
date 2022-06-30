import 'package:flutter/material.dart';

class PasswordsNotMatchDialog extends StatelessWidget {

  final String message;

  const PasswordsNotMatchDialog({
    Key? key, this.message = 'Verifique suas senhas, pois elas não são iguais'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Senhas diferentes'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );
  }
}
