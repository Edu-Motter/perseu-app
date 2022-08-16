import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/screens/athlete_drawer/athlete_drawer.dart';
import 'package:perseu/src/screens/coach_home/coach_home_viewmodel.dart';
import 'package:perseu/src/utils/trigger.dart';
import 'package:provider/provider.dart';

class CoachHomeScreen extends StatelessWidget {
  CoachHomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<CoachHomeViewModel>(),
      child: Consumer<CoachHomeViewModel>(
        builder: (BuildContext context, model, _) {
          return Trigger(
            onCreate: () => model.getTeamInfo(),
            child: Scaffold(
                key: scaffoldKey,
                drawer: const AthleteDrawer(),
                appBar: AppBar(
                  title: Text('Olá, ${model.userName}!'),
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
                        Text(model.teamName,
                            style: const TextStyle(fontSize: 32)),
                        Text('${model.teamSize} atletas', style: const TextStyle(fontSize: 20)),
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
                            Navigator.of(context)
                                .pushNamed(Routes.changeTeamName);
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
                ])),
          );
        },
      ),
    );
  }
}
