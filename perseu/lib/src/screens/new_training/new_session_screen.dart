import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/screens/new_training/new_exercise_screen.dart';

import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/style.dart';
import 'package:perseu/src/utils/ui.dart';

class NewSessionScreen extends StatefulWidget {
  const NewSessionScreen({Key? key, this.sessionModel}) : super(key: key);
  final SessionModel? sessionModel;

  get hasSession => sessionModel != null ? true : false;

  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSessionScreen> {
  final TextEditingController _sessionNameController = TextEditingController();
  late SessionModel sessionModel;

  @override
  void initState() {
    if (widget.hasSession) {
      _sessionNameController.text = widget.sessionModel!.name;
      sessionModel = SessionModel(
          id: widget.sessionModel!.id,
          name: widget.sessionModel!.name,
          exercises: widget.sessionModel!.exercises);
    } else {
      sessionModel = SessionModel(id: 1, name: '', exercises: []);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.background,
        appBar: AppBar(
          title: widget.hasSession
              ? const Text('Editando sessão')
              : const Text('Nova sessão'),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Style.primary,
          foregroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              backgroundColor: Style.accent,
              foregroundColor: Colors.white,
              labelBackgroundColor: Style.accent,
              child: const Icon(Icons.save),
              onTap: () {
                String sessionName = _sessionNameController.text;
                if (sessionName.isNotEmpty &&
                    sessionModel.exercises.isNotEmpty) {
                  sessionModel.name = sessionName;
                  Navigator.of(context).pop(sessionModel);
                } else {
                  UIHelper.showError(
                      context,
                      const Result.error(
                          message:
                              'Preencha o nome da sessão e crie um exercício'));
                }
              },
              label: 'Salvar sessão',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SpeedDialChild(
              backgroundColor: Style.accent,
              foregroundColor: Colors.white,
              labelBackgroundColor: Style.accent,
              child: const Icon(Icons.add),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Routes.newExercise)
                    .then((exerciseFuture) {
                  ExerciseModel exerciseModel = exerciseFuture as ExerciseModel;
                  setState(() {
                    sessionModel.exercises.add(exerciseModel);
                  });
                });
              },
              label: 'Adicionar exercício',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _sessionNameController,
                    style: const TextStyle(color: Style.primary),
                    decoration:
                        const InputDecoration(labelText: 'Nome da sessão'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 56),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: sessionModel.exercises.length,
                  itemBuilder: (context, index) {
                    ExerciseModel exercise = sessionModel.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: Style.accent, width: 5),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Style.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              exercise.description,
                              style: const TextStyle(color: Style.secondary),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Style.accent,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => NewExerciseScreen(
                                                exerciseModel: exercise)))
                                        .then((exerciseFuture) {
                                      ExerciseModel exerciseModel =
                                          exerciseFuture as ExerciseModel;
                                      setState(() {
                                        sessionModel.exercises.removeWhere(
                                            (e) => e.id == exerciseModel.id);
                                        sessionModel.exercises
                                            .insert(index, exerciseModel);
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Style.accent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sessionModel.exercises.removeAt(index);
                                      });
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
