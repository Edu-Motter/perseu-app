import 'package:flutter/material.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/utils/style.dart';

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
    if (widget.hasExercise) {
      _exerciseDescriptionController.text = widget.exerciseModel!.description;
      _exerciseNameController.text = widget.exerciseModel!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.background,
        appBar: AppBar(
          title: widget.hasExercise
              ? const Text('Editando exercício')
              : const Text('Novo exercício'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextField(
              controller: _exerciseNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Exercício',
              ),
            ),
            TextField(
              controller: _exerciseDescriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Descrição do Exercício',
              ),
            ),
            Expanded(
                child: Container(
              color: Style.background,
            )),
            ElevatedButton(
                onPressed: () {
                  String exerciseName = _exerciseNameController.text;
                  String exerciseDescription =
                      _exerciseDescriptionController.text;
                  if (exerciseName.isNotEmpty &&
                      exerciseDescription.isNotEmpty) {
                    ExerciseModel exerciseModel = ExerciseModel(
                        id: widget.hasExercise ? widget.exerciseModel!.id : 10,
                        name: exerciseName,
                        description: exerciseDescription);
                    Navigator.of(context).pop(exerciseModel);
                  }
                },
                child: const Text('Salvar exercício',
                    style: TextStyle(fontSize: 16)))
          ]),
        ));
  }
}
