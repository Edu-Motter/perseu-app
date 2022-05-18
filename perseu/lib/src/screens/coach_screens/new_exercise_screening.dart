import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:uuid/uuid.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({Key? key, this.exerciseModel}) : super(key: key);

  final ExerciseModel? exerciseModel;

  get hasExercise => exerciseModel != null ? true : false;

  @override
  _NewExerciseState createState() => _NewExerciseState();
}

class _NewExerciseState extends State<NewExerciseScreen> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseDescriptionController =
      TextEditingController();

  @override
  void initState() {
    if(widget.hasExercise){
      _exerciseDescriptionController.text = widget.exerciseModel!.description;
      _exerciseNameController.text = widget.exerciseModel!.name;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.hasExercise
              ? const Text('Editando exercício')
              : const Text('Novo exercício'),
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
                String exerciseDescription =
                    _exerciseDescriptionController.text;
                if (exerciseName.isNotEmpty && exerciseDescription.isNotEmpty) {
                  ExerciseModel exerciseModel = ExerciseModel(
                      id: widget.hasExercise ? widget.exerciseModel!.id : const Uuid().v4(),
                      name: exerciseName,
                      description: exerciseDescription);
                  Navigator.of(context).pop(exerciseModel);
                }
              },
              child: const Text('Salvar exercício',
                  style: TextStyle(fontSize: 16)))
        ]));
  }
}
