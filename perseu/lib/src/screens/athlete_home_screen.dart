import 'package:flutter/material.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';

class AthleteHomeScreen extends StatelessWidget {
  const AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Olá, usuário!'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  title: 'Visualizar treino de hoje',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 32),
                MenuButton(
                  title: 'Visualizar conversas',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Visualizar calendário',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Gerenciar perfil',
                  onPressed: () {
                    null;
                  },
                ),
              ],
            ),
          ),
        ]));
  }
}
