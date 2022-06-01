import 'package:flutter/material.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';

import '../app/routes.dart';
import 'athlete_drawer/athlete_drawer.dart';


class AthleteHomeScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: scaffoldKey,
        drawer: const AthleteDrawer(),
        appBar: AppBar(
          title: const Text('Olá, usuário!'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.bootstrap);
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Visualizar ingresso equipe',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.athleteRequest);
                  },
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Gerenciar perfil',
                  onPressed: () {
                    null;
                  },
                )
              ],
            ),
          ),
        ));
  }
}
