import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/screens/new_training/new_exercise_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
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
        backgroundColor: Palette.background,
        appBar: AppBar(
          title: widget.hasSession
              ? const Text('Editar sessão')
              : const Text('Nova sessão'),
        ),
        floatingActionButton: SpeedDial(
          backgroundColor: Palette.primary,
          foregroundColor: Colors.white,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              backgroundColor: Palette.accent,
              foregroundColor: Colors.white,
              labelBackgroundColor: Palette.accent,
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
              backgroundColor: Palette.accent,
              foregroundColor: Colors.white,
              labelBackgroundColor: Palette.accent,
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
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _sessionNameController,
                    style: const TextStyle(color: Palette.primary),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Nome da Sessão',
                      labelText: 'Nome da Sessão',
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: sessionModel.exercises.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Crie um exercício em "Adicionar exercício"'),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(Routes.newExercise)
                                      .then((exerciseFuture) => _handleAddExercise(exerciseFuture as ExerciseModel, 0)
                                    );
                                },
                                child: const Text('Adicionar exercício')),
                          )
                        ],
                      ))
                  : ListView.builder(
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
                                  top: BorderSide(
                                      color: Palette.accent, width: 5),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                title: Text(
                                  exercise.name,
                                  style: const TextStyle(
                                    color: Palette.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  exercise.description,
                                  style:
                                      const TextStyle(color: Palette.secondary),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Palette.accent,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) =>
                                                    NewExerciseScreen(
                                                        exerciseModel:
                                                            exercise)))
                                            .then((exerciseFuture) =>
                                          _handleAddExercise(exerciseFuture, index)
                                        );
                                      },
                                    ),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Palette.accent,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            sessionModel.exercises
                                                .removeAt(index);
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

  void _handleAddExercise(ExerciseModel exerciseFuture, index) {
    ExerciseModel exerciseModel = exerciseFuture;
    setState(() {
      sessionModel.exercises.removeWhere((e) => e.id == exerciseModel.id);
      sessionModel.exercises.insert(index, exerciseModel);
    });
  }
}
