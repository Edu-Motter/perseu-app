import 'package:flutter/material.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/screens/new_training/new_training_viewmodel.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../../services/foundation.dart';

class NewExerciseScreen extends StatefulWidget {
  final ExerciseModel? exerciseModel;
  final NewTrainingViewModel model;
  final int? index;

  const NewExerciseScreen({
    Key? key,
    required this.model,
    this.exerciseModel,
    this.index,
  }) : super(key: key);

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
    return ChangeNotifierProvider.value(
      value: widget.model,
      child: Consumer<NewTrainingViewModel>(
        builder: (_, model, __) {
          return WillPopScope(
            onWillPop: () => confirmEraseExercise(context),
            child: Scaffold(
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
                    if (!widget.hasExercise)
                      Column(
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Palette.accent, width: 2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => saveExercise(context, model, true),
                              child: const Text(
                                'Salvar e novo',
                                style: TextStyle(color: Palette.accent),
                              )),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ElevatedButton(
                        onPressed: () => saveExercise(context, model, false),
                        child:
                            const Text('Salvar', style: TextStyle(fontSize: 16)))
                  ]),
                )),
          );
        },
      ),
    );
  }

  void saveExercise(
      BuildContext context, NewTrainingViewModel model, bool saveNew) {
    String exerciseName = _exerciseNameController.text.trim();
    String exerciseDescription = _exerciseDescriptionController.text.trim();

    if (exerciseName.isEmpty || exerciseDescription.isEmpty) {
      UIHelper.showError(
          context,
          const Result.error(
              message: 'Preencha o nome e a descrição do exercício'));
      return;
    }

    final exercise = model.createExercise(
      id: widget.hasExercise ? widget.exerciseModel!.id : null,
      name: exerciseName,
      description: exerciseDescription,
    );
    model.saveExercise(exercise, widget.index);

    if (saveNew) {
      resetValues(model);
      UIHelper.showSuccess(
          context, const Result.success(message: 'Salvo com sucesso'));
    } else {
      Navigator.of(context).pop();
    }
  }

  void resetValues(NewTrainingViewModel model) {
    _exerciseDescriptionController.text = '';
    _exerciseNameController.text = '';
    model.notifyListeners();
  }

  Future<bool> confirmEraseExercise(BuildContext context) async {
    final result = await UIHelper.showBool(
        context: context,
        title: 'Apagar exercício?',
        message: 'Deseja realmente sair sem salvar o exercício');
    return Future.value(result ?? false);
  }
}
