import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/coach_screens/new_session_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/ui.dart';
import '../coach_assign_training/assign_training_screen.dart';

class NewTrainingScreen extends StatefulWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  State<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  final TrainingModel training = TrainingModel(
    id: 0,
    sessions: <SessionModel>[],
  );

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
            onTap: () => {
              if (training.sessions.isNotEmpty)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => AssignTrainingScreen(training: training)))
              else
                UIHelper.showError(
                    context,
                    const Result.error(
                        message: 'Não há sessões para serem atribuidas'))
            },
            label: 'Atribuir treino',
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
      body: training.sessions.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                          'Crie uma sessão de exercícios em "Adicionar sessão"')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routes.newSession)
                            .then((sessionFuture) {
                          SessionModel session = sessionFuture as SessionModel;
                          setState(() {
                            training.sessions.add(session);
                          });
                        });
                      },
                      child: const Text('Adicionar sessão'))
                ],
              ))
          : ListView.builder(
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
                                    builder: (_) => NewSessionScreen(
                                        sessionModel: session)))
                                .then((sessionFuture) {
                              SessionModel sessionModel =
                                  sessionFuture as SessionModel;
                              setState(() {
                                training.sessions.removeWhere(
                                    (e) => e.id == sessionModel.id);
                                training.sessions.insert(index, sessionModel);
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
              }),
    );
  }
}
