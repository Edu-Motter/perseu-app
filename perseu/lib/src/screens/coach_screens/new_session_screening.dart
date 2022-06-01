import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/screens/coach_screens/new_exercise_screening.dart';

class NewSessionScreen extends StatefulWidget {
  const NewSessionScreen({Key? key}) : super(key: key);

  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSessionScreen> {
  final TextEditingController _sessionNameController = TextEditingController();
  late SessionModel sessionModel;

  @override
  void initState() {
    sessionModel = SessionModel(id: 0, name: '', exercises: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nova sessão'),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.save),
              onTap: () {
                String sessionName = _sessionNameController.text;
                if (sessionName.isNotEmpty) {
                  sessionModel.name = sessionName;
                  Navigator.of(context).pop(sessionModel);
                }
              },
              label: 'Salvar sessão',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            SpeedDialChild(
              child: const Icon(Icons.add),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(Routes.newExercice)
                    .then((exerciseFuture) {
                  ExerciseModel exerciseModel = exerciseFuture as ExerciseModel;
                  setState(() {
                    sessionModel.exercises.add(exerciseModel);
                  });
                });
              },
              label: 'Adicionar exercício',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _sessionNameController,
                      decoration: const InputDecoration(labelText: 'Nome da sessão'),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: sessionModel.exercises.length,
                  itemBuilder: (context, index) {
                    ExerciseModel exercise = sessionModel.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.edit),
                          tileColor: Colors.teal[100],
                          title: Text(exercise.name),
                          subtitle: Text(exercise.description),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (_) => NewExerciseScreen(
                                        exerciseModel: exercise)))
                                .then((exerciseFuture) {
                              ExerciseModel exerciseModel =
                                  exerciseFuture as ExerciseModel;
                              setState(() {
                                sessionModel.exercises.removeWhere((e) => e.id == exerciseModel.id);
                                sessionModel.exercises.add(exerciseModel);
                              });
                            });
                          },
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
