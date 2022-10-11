import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/screens/athlete_home/athlete_home_viewmodel.dart';
import 'package:perseu/src/states/session.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../athlete_drawer/athlete_drawer.dart';

class AthleteHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AthleteHomeViewModel>(),
      child: Consumer<AthleteHomeViewModel>(
        builder: (BuildContext context, model, _) {
          return Scaffold(
              key: scaffoldKey,
              drawer: const UserDrawer(),
              appBar: AppBar(
                title: Consumer<Session>(builder: (_, session, __) {
                  return Text('Olá, ${model.athleteName}!');
                }),
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
                          Navigator.of(context)
                              .pushNamed(Routes.userViewTraining);
                        },
                      ),
                      const SizedBox(height: 32),
                      MenuButton(
                        title: 'Visualizar conversas',
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.teamChat);
                        },
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
        },
      ),
    );
  }
}
