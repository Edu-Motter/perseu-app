import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/buttons/menu_button.dart';
import 'package:perseu/src/models/dtos/team_info_dto.dart';
import 'package:perseu/src/screens/new_training/new_training_screen.dart';
import 'package:perseu/src/screens/user_drawer/user_drawer.dart';
import 'package:perseu/src/screens/coach_home/coach_home_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/session.dart';
import 'package:perseu/src/utils/style.dart';
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
            backgroundColor: Style.background,
            key: scaffoldKey,
            drawer: const UserDrawer(),
            appBar: AppBar(
              title: Consumer<Session>(builder: (_, session, __) {
                return Text('Olá, ${model.coachName}!');
              }),
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
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TeamInfo(
                        futureTeamInfo: model.getTeamInfo(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          FirstColumnMenuItems(),
                          SecondColumnMenuItems(),
                        ],
                      ),
                      const SizedBox(height: 24),
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

class FirstColumnMenuItems extends StatelessWidget {
  const FirstColumnMenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CoachHomeViewModel>(context, listen: false);

    return Column(
      children: [
        MenuButton(
          text: 'Novo Treino',
          icon: Icons.description_outlined,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const TrainingNameDialog(),
          ),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Lista de Treinos',
          icon: Icons.list,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.trainingsByTeam),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Visualizar Conversas',
          icon: Icons.message_outlined,
          onPressed: () => Navigator.of(context).pushNamed(Routes.chats),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Alterar nome equipe',
          icon: Icons.edit_outlined,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(Routes.changeTeamName)
                .then((_) => model.refresh());
          },
        ),
      ],
    );
  }
}

class SecondColumnMenuItems extends StatelessWidget {
  const SecondColumnMenuItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuButton(
          text: 'Gerenciar Solicitações',
          icon: Icons.notifications_active_outlined,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.manageInvites),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Gerenciar Atletas',
          icon: Icons.group_outlined,
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.manageAthletes),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Gerenciar Perfil',
          icon: Icons.person_outline,
          onPressed: () => Navigator.of(context).pushNamed(Routes.profile),
        ),
        const SizedBox(height: 24),
        MenuButton(
          text: 'Placeholder',
          icon: Icons.cancel_outlined,
          onPressed: () {},
        ),
      ],
    );
  }
}

class TrainingNameDialog extends StatefulWidget {
  const TrainingNameDialog({Key? key}) : super(key: key);

  @override
  State<TrainingNameDialog> createState() => _TrainingNameDialogState();
}

class _TrainingNameDialogState extends State<TrainingNameDialog> {
  final TextEditingController _nameController = TextEditingController();
  bool get valid => _nameController.text.length > 2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Nome do treino',
        style: TextStyle(color: Style.primary),
      ),
      content: TextField(
        style: const TextStyle(color: Style.primary),
        controller: _nameController,
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Style.primary),
                minimumSize: MaterialStateProperty.all(const Size(0, 32))),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar')),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(valid ? Style.accent : Colors.grey),
              minimumSize: MaterialStateProperty.all(const Size(0, 32))),
          onPressed: valid
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewTrainingScreen(
                        trainingName: _nameController.text,
                      ),
                    ),
                  );
                }
              : null,
          child: const Text(
            'Continuar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
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
                      '${teamInfo.numberOfAthletes} atletas',
                      style:
                          style.copyWith(fontSize: 20, color: Style.secondary),
                    ),
                    const SizedBox(height: 16),
                    if (showCode)
                      Text(
                        'Código de acesso: ${teamInfo.code}',
                        style: const TextStyle(
                            color: Style.background, fontSize: 16),
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
