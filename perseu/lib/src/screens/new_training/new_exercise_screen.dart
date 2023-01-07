import 'package:flutter/material.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/utils/palette.dart';

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
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.background,
        appBar: AppBar(
          title: widget.hasExercise
              ? const Text('Editar exercício')
              : const Text('Novo exercício'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            TextFormField(
              controller: _exerciseNameController,
              style: const TextStyle(color: Palette.primary),
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                hintText: 'Nome do exercício',
                labelText: 'Nome do exercício',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _exerciseDescriptionController,
              style: const TextStyle(color: Palette.primary),
              keyboardType: TextInputType.multiline,
              minLines: 6,
              maxLines: 6,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                hintText: 'Descrição do exercício',
                labelText: 'Descrição do exercício',
              ),
            ),
            Expanded(
                child: Container(
              color: Palette.background,
            )),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      side: BorderSide(color: Palette.accent, width: 2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Salvar e novo',
                  style: TextStyle(color: Palette.accent),
                )),
            const SizedBox(height: 8),
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
                child: const Text('Salvar', style: TextStyle(fontSize: 16)))
          ]),
        ));
  }
}
