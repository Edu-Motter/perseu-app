import 'package:flutter/material.dart';

class NewSessionScreen extends StatelessWidget {
  const NewSessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nova sessão'),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('sessão')],
            ),
          ),
        ]));
  }
}
