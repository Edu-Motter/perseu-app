import 'package:flutter/material.dart';

class EmailAlreadyExists extends StatelessWidget {

  final String message;

  const EmailAlreadyExists({
    Key? key, this.message = 'Esse e-mail já está em uso'
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('E-mail não disponível'),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'))
      ],
    );
  }
}
