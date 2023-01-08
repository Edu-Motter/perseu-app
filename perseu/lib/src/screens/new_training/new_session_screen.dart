import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/screens/new_training/new_exercise_screen.dart';
import 'package:perseu/src/screens/new_training/new_training_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

class NewSessionScreen extends StatefulWidget {
  final NewTrainingViewModel model;
  final SessionModel? sessionModel;
  final int? index;

  const NewSessionScreen({
    Key? key,
    required this.model,
    this.sessionModel,
    this.index,
  }) : super(key: key);

  @override
  _NewSessionState createState() => _NewSessionState();
}

class _NewSessionState extends State<NewSessionScreen> {
  final TextEditingController _sessionNameController = TextEditingController();

  bool get editingSession => widget.sessionModel != null;

  @override
  void initState() {
    if (editingSession) {
      _sessionNameController.text = widget.sessionModel!.name;
      widget.model.baseSession = SessionModel(
        id: widget.sessionModel!.id,
        name: widget.sessionModel!.name,
        exercises: widget.sessionModel!.exercises,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.model,
      child: Consumer<NewTrainingViewModel>(
        builder: (_, model, __) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: editingSession
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
                  onTap: () => saveSession(context, model),
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NewExerciseScreen(model: model),
                    ));
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
                  child: model.baseSession.exercises.isEmpty
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            NewExerciseScreen(model: model),
                                      ));
                                    },
                                    child: const Text('Adicionar exercício')),
                              )
                            ],
                          ))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 56),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: model.baseSession.exercises.length,
                          itemBuilder: (context, index) {
                            ExerciseModel exercise =
                                model.baseSession.exercises[index];
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
                                      style: const TextStyle(
                                          color: Palette.secondary),
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
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    NewExerciseScreen(
                                                  exerciseModel: exercise,
                                                  model: model,
                                                  index: index,
                                                ),
                                              ),
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
                                                model.baseSession.exercises
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
            ),
          );
        },
      ),
    );
  }

  void saveSession(BuildContext context, NewTrainingViewModel model) {
    String sessionName = _sessionNameController.text.trim();

    if (sessionName.isEmpty || model.baseSession.exercises.isEmpty) {
      UIHelper.showError(
        context,
        const Result.error(
            message: 'Preencha o nome da sessão e crie um exercício'),
      );
      return;
    }

    model.baseSession.name = sessionName;

    SessionModel session = model.createSession(
      id: editingSession ? widget.sessionModel!.id : null,
      name: sessionName,
    );
    model.saveSession(session, widget.index);
    Navigator.of(context).pop();
  }
}
