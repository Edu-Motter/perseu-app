import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/coach_screens/new_session_screening.dart';

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
              Navigator.of(context)
                  .pushNamed(Routes.newSession)
                  .then((sessionFuture) {
                SessionModel session = sessionFuture as SessionModel;
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        training.sessions.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) =>
                                  NewSessionScreen(sessionModel: session)))
                          .then((sessionFuture) {
                        SessionModel sessionModel =
                            sessionFuture as SessionModel;
                        setState(() {
                          training.sessions
                              .removeWhere((e) => e.id == sessionModel.id);
                          training.sessions.add(sessionModel);
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    )),
                const Padding(
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
            Text(exerciseModel.description),
          ],
        ),
      ),
    );
  }
}
