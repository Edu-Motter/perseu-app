import 'package:flutter/material.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';

import '../app/routes.dart';
import 'athlete_drawer/athlete_drawer.dart';

class AthleteHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: const AthleteDrawer(),
        appBar: AppBar(
          title: const Text('Olá, atleta!'),
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
                    Navigator.of(context).pushNamed(Routes.userViewTraining);
                  },
                ),
                const SizedBox(height: 32),
                MenuButton(
                  title: 'Visualizar conversas',
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                MenuButton(
                  title: 'Gerenciar perfil',
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.profile);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
