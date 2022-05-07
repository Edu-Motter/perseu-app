import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';

class NewTrainingScreen extends StatefulWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  State<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  late TrainingModel training;
  @override
  void initState() {
    training = TrainingModel(id: 1, name: 'nomeee', sessions: [
      SessionModel(
        id: 1,
        name: 'Aquecimento',
        exercises: [
          ExerciseModel(
              id: 1, name: 'Alongamento leve', description: 'Alongar articulações das pernas e braços por 10 segundos'),
          ExerciseModel(id: 1, name: 'Corrida', description: 'Trote na pista, de 8 a 10 minutos')
        ],
      ),
      SessionModel(id: 1, name: 'Exercício pernas', exercises: [
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(id: 1, name: 'Leg press', description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(
            id: 1, name: 'Salto em degrau', description: 'Realizar salto em degraus grandes, subida e descida 3x')
      ])
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.of(context).pushNamed(Routes.newSession).then((sessionFuture) {
                SessionModel session = sessionFuture as SessionModel;
                debugPrint(session.toString());
                setState(() {
                  training.sessions.add(session);
                });
              });
            },
            label: 'Adicionar sessão',
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
          SpeedDialChild(
            child: const Icon(Icons.forward),
            onTap: () => Navigator.of(context).pushNamed(Routes.newSession),
            label: 'Atribuir treino',
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
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
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Text(session.name),
            children: [for (ExerciseModel e in session.exercises) ExerciseCard(exerciseModel: e)],
          ));
        },
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final ExerciseModel exerciseModel;

  const ExerciseCard({Key? key, required this.exerciseModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              exerciseModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(exerciseModel.description)
          ],
        ),
      ),
    );
  }
}
