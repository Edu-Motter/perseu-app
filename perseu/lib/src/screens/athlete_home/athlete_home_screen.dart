import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer.dart';
import 'package:perseu/src/screens/athlete_home/athlete_home_viewmodel.dart';
import 'package:perseu/src/states/session.dart';
import 'package:provider/provider.dart';

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
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MenuButton(
                            icon: Icons.description,
                            text: 'Visualizar treino',
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.userViewTraining);
                            },
                          ),
                          const SizedBox(height: 24),
                          MenuButton(
                            icon: Icons.message,
                            text: 'Visualizar conversas',
                            onPressed: () =>
                                Navigator.of(context).pushNamed(Routes.chats),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MenuButton(
                            icon: Icons.person,
                            text: 'Gerenciar perfil',
                            onPressed: () =>
                                Navigator.of(context).pushNamed(Routes.profile),
                          ),
                          const SizedBox(height: 24),
                          MenuButton(
                            icon: Icons.check,
                            text: 'Check-ins',
                            onPressed: () =>
                                Navigator.of(context).pushNamed(Routes.athleteChecks),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
