import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/screens/athlete_drawer/athlete_drawer.dart';
import 'package:perseu/src/screens/coach_home/coach_home_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
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
          return Scaffold(
            key: scaffoldKey,
            drawer: const UserDrawer(),
            appBar: AppBar(
              title: Text('Olá, ${model.userName}'),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TeamInfo(
                        futureTeamInfo: model.getTeamInfo(),
                        style: const TextStyle(color: Colors.black),
                      ),
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
                              .pushNamed(Routes.changeTeamName)
                              .then((_) => model.refresh());
                        },
                      ),
                      const SizedBox(height: 8),
                      MenuButton(
                        title: 'Gerenciar perfil',
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.profile);
                        },
                      ),
                      const SizedBox(height: 32),
                      MenuButton(
                        title: 'Visualizar conversas',
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.teamChat);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TeamInfo extends StatelessWidget {
  const TeamInfo({
    Key? key,
    required this.futureTeamInfo,
    required this.style,
    this.showCode = false,
  }) : super(key: key);

  final Future<Result<TeamInfoDTO>> futureTeamInfo;
  final TextStyle style;
  final bool showCode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureTeamInfo,
      builder: (context, AsyncSnapshot<Result<TeamInfoDTO>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasData) {
              Result result = snapshot.data!;
              if (result.error) {
                return Center(
                  child: Text(result.message ?? 'Erro não informado'),
                );
              } else {
                TeamInfoDTO teamInfo = result.data!;
                return Column(
                  children: [
                    Text(
                      teamInfo.name,
                      style: style.copyWith(fontSize: 32),
                    ),
                    Text(
                      '${teamInfo.id} atletas',
                      style: style.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    if (showCode)
                      Text(
                        'Código de acesso: ${teamInfo.code}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                  ],
                );
              }
            } else {
              return const Center(
                child: Text('Nenhuma informação foi encontrada'),
              );
            }
        }
      },
    );
  }
}
