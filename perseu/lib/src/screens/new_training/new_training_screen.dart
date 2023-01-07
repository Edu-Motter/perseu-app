import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';

import 'new_session_screen.dart';

class NewTrainingScreen extends StatefulWidget {
  const NewTrainingScreen({Key? key, required this.trainingName})
      : super(key: key);

  final String trainingName;

  @override
  State<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  final TrainingModel training = TrainingModel(
    name: '',
    id: 0,
    sessions: <SessionModel>[],
  );

  @override
  void initState() {
    training.name = widget.trainingName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.background,
      appBar: AppBar(
        title: Text('Novo treino - ${widget.trainingName}'),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Palette.primary,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 22.0),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            backgroundColor: Palette.accent,
            foregroundColor: Colors.white,
            labelBackgroundColor: Palette.accent,
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
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SpeedDialChild(
            backgroundColor: Palette.accent,
            foregroundColor: Colors.white,
            labelBackgroundColor: Palette.accent,
            child: const Icon(Icons.forward),
            onTap: () => {
              if (training.sessions.isNotEmpty)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        AthletesAssignTrainingScreen(training: training)))
              else
                UIHelper.showError(
                    context,
                    const Result.error(
                        message: 'Não há sessões para serem atribuidas'))
            },
            label: 'Atribuir treino',
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: training.sessions.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Crie uma sessão de exercícios em "Adicionar sessão"'),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(Routes.newSession)
                              .then((sessionFuture) =>
                                  _handleAddSession(sessionFuture));
                        },
                        child: const Text('Adicionar sessão')),
                  )
                ],
              ))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: training.sessions.length,
              itemBuilder: (context, index) {
                SessionModel session = training.sessions[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    color: Colors.white,
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
                                    training.sessions
                                        .insert(index, sessionModel);
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
                      title: Text(
                        session.name,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Palette.primary,
                            fontWeight: FontWeight.w500),
                      ),
                      children: [
                        for (ExerciseModel e in session.exercises)
                          ExerciseCard(
                            name: e.name,
                            description: e.description,
                          )
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  void _handleAddSession(sessionFuture) {
    if (sessionFuture == null) return;
    SessionModel session = sessionFuture as SessionModel;
    setState(() {
      training.sessions.add(session);
    });
  }
}
