import 'package:flutter/material.dart';
import 'package:perseu/src/utils/palette.dart';

class CoachCreatesTeam extends StatelessWidget {
  const CoachCreatesTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: const Text('Criar uma equipe'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Para iniciar no app Perseu, informe o nome da sua equipe',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome da equipe',
              ),
            ),
          ),
          const ElevatedButton(onPressed: null, child: Text('Cadastrar'))
        ],
      ),
    );
  }
}
