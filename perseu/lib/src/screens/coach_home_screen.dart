import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';

class CoachHomeScreen extends StatelessWidget {
  const CoachHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Equipe Teste', style: TextStyle(fontSize: 32)),
                const Text('33 atletas', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                CustomButton(
                  title: 'Novo treino',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.newTraining);
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  title: 'Gerenciar grupos',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  title: 'Gerenciar solicitações',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.manageInvites);
                  },
                ),
                const SizedBox(height: 8),
                CustomButton(
                  title: 'Gerenciar relatórios',
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
