import 'package:flutter/material.dart';

class CoachCreatesTeam extends StatelessWidget {
  const CoachCreatesTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Criando uma equipe'),
        ),
        body: ListView(children: [
          const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  'Para iniciar no app Perseu, informe o nome da sua equipe')),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome da equipe',
                ),
              )),
          const ElevatedButton(onPressed: null, child: Text('Cadastrar'))
        ]));
  }
}
