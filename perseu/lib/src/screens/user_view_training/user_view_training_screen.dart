import 'package:flutter/material.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';

class UserViewTrainingScreen extends StatefulWidget {
  const UserViewTrainingScreen({Key? key}) : super(key: key);

  @override
  State<UserViewTrainingScreen> createState() => _UserViewTrainingScreenState();
}

class _UserViewTrainingScreenState extends State<UserViewTrainingScreen> {
  late TrainingModel training;
  @override
  void initState() {
    training = TrainingModel(id: 1, name: 'treino forte', sessions: [
      SessionModel(
        id: 0,
        name: 'Aquecimento',
        exercises: [
          ExerciseModel(
              id: '0',
              name: 'Alongamento leve',
              description:
                  'Alongar articulações das pernas e braços por 10 segundos'),
          ExerciseModel(
              id: '1',
              name: 'Corrida',
              description: 'Trote na pista, de 8 a 10 minutos')
        ],
      ),
      SessionModel(id: 1, name: 'Exercício pernas', exercises: [
        ExerciseModel(
            id: '0',
            name: 'Leg press',
            description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(
            id: '1',
            name: 'Leg press',
            description: 'Fazer leg press 45 com 140kg, 3x10'),
      ])
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar treino'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: training.sessions.length,
        itemBuilder: (context, index) {
          SessionModel session = training.sessions[index];
          return Card(
              child: ExpansionTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.keyboard_arrow_down),
                )
              ],
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Text(session.name),
            children: [
              for (ExerciseModel e in session.exercises)
                ExerciseCard(exerciseModel: e)
            ],
          ));
        },
      ),
    );
  }
}
