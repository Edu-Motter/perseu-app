import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/screens/athlete_drawer/athlete_drawer.dart';

class CoachHomeScreen extends StatelessWidget {
  CoachHomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const AthleteDrawer(),
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
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
                MenuButton(
                  title: 'Novo treino',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.newTraining);
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Nova equipe',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.newTeam);
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Gerenciar solicitações',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.manageInvites);
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Gerenciar relatórios',
                  onPressed: () {
                    null;
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Alterar nome equipe',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.changeTeamName);
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
