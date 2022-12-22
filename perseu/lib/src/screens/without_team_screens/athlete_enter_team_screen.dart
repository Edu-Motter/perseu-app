import 'package:flutter/material.dart';
import 'package:perseu/src/utils/palette.dart';

class AthleteEnterTeam extends StatelessWidget {
  const AthleteEnterTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.background,
        appBar: AppBar(
          title: const Text('Entrar em uma equipe'),
        ),
        body: ListView(children: [
          const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Código de acesso: 12345')),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Código de acesso',
                ),
              )),
          const ElevatedButton(onPressed: null, child: Text('Solicitar para entrar'))
        ]));
  }
}
