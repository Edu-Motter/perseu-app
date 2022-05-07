import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({Key? key}) : super(key: key);

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExerciseScreen> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseDescriptionController = TextEditingController();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo exercício'),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.check),
              onTap: () {
                Navigator.of(context).pop();
              },
              label: 'Salvar exercício',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: [
          TextField(
            controller: _exerciseNameController,
            decoration: const InputDecoration(
              labelText: 'Nome do Exercício',
            ),
          ),
          TextField(
            controller: _exerciseDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição do Exercício',
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
              onPressed: () {
                String exerciseName = _exerciseNameController.text;
                String exerciseDescription = _exerciseDescriptionController.text;
                if (exerciseName.isNotEmpty && exerciseDescription.isNotEmpty) {
                  ExerciseModel exerciseModel =
                      ExerciseModel(id: 0, name: exerciseName, description: exerciseDescription);
                  Navigator.of(context).pop(exerciseModel);
                }
              },
              child: const Text('Salvar exercício', style: TextStyle(fontSize: 16)))
        ]));
  }
}
