import 'package:flutter/material.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';

class AthleteHomeScreen extends StatelessWidget {
  const AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;

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
                CustomButton(
                  title: 'Visualizar treino de hoje',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  title: 'Visualizar conversas',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  title: 'Visualizar calendário',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
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
