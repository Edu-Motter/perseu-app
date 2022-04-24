import 'package:flutter/material.dart';
import 'package:perseu/src/components/training_list/training_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';

class NewTrainingScreen extends StatelessWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TrainingModel training = TrainingModel(id: 1, name: 'nomeee', sessions: [
      SessionModel(
        id: 1,
        name: 'nome sesão',
        exercises: [
          ExerciseModel(
              id: 1, name: 'exercício top', description: 'descrição top'),
          ExerciseModel(
              id: 1, name: 'exercício top 2', description: 'mais cansado nessa')
        ],
      ),
      SessionModel(id: 1, name: 'nome sesão 2', exercises: [
        ExerciseModel(
            id: 1, name: 'exercício top', description: 'descrição top'),
        ExerciseModel(
            id: 1, name: 'exercício já acabou', description: 'mds n acaba')
      ])
    ]);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo treino'),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(Routes.newSession),
              label: 'Adicionar sessão',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            SpeedDialChild(
              child: const Icon(Icons.forward),
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed(Routes.newSession),
              label: 'Atribuir treino',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrainingSessionList(
                  training: training,
                )
              ],
            ),
          ),
        ]));
  }
}
