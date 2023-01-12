import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_screen.dart';
import 'package:perseu/src/screens/new_training/new_training_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'new_session_screen.dart';

class NewTrainingScreen extends StatefulWidget {
  const NewTrainingScreen({Key? key, required this.trainingName})
      : super(key: key);

  final String trainingName;

  @override
  State<NewTrainingScreen> createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewTrainingViewModel>(
      create: (_) => locator<NewTrainingViewModel>(),
      child: Consumer<NewTrainingViewModel>(
        builder: (_, model, __) {
          model.training.name = widget.trainingName;
          return WillPopScope(
            onWillPop: () => confirmEraseTraining(context),
            child: Scaffold(
              backgroundColor: Palette.background,
              appBar: AppBar(
                title: Text('Novo treino - ${widget.trainingName}'),
              ),
              floatingActionButton: model.hasNoSession
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 56.0),
                      child: FloatingActionButton(
                        backgroundColor: Palette.secondary,
                        child: const Icon(Icons.add),
                        onPressed: () => goToSession(context, model),
                      ),
                    ),
              body: model.hasNoSession
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Inicie criando uma sessão',
                            style: TextStyle(
                                color: Palette.primary,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: ElevatedButton(
                                onPressed: () => goToSession(context, model),
                                child: const Text('Adicionar sessão')),
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: model.training.sessions.length,
                            itemBuilder: (context, index) {
                              SessionModel session =
                                  model.training.sessions[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  color: Colors.white,
                                  child: ExpansionTile(
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () => confirmRemove(
                                                context, index, model),
                                            icon: const Icon(
                                              Icons.clear,
                                              size: 24,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      NewSessionScreen(
                                                    model: model,
                                                    index: index,
                                                    sessionModel: session,
                                                  ),
                                                ),
                                              );
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
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => saveTraining(context, model),
                            child: const Text(
                              'Salvar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  void goToSession(BuildContext context, NewTrainingViewModel model) {
    model.startNewSession();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewSessionScreen(model: model)),
    );
  }

  void saveTraining(BuildContext context, NewTrainingViewModel model) {
    if (!model.hasNoSession) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              AthletesAssignTrainingScreen(training: model.training),
        ),
      );
    } else {
      UIHelper.showError(
        context,
        const Result.error(message: 'Adicione sessões para salvar'),
      );
    }
  }

  void confirmRemove(
    BuildContext context,
    int index,
    NewTrainingViewModel model,
  ) {
    String sessionName = model.training.sessions[index].name;
    UIHelper.showBoolDialog(
      context: context,
      onNoPressed: () => Navigator.pop(context),
      onYesPressed: () async {
        await model.removeSession(index);
        Navigator.pop(context);
      },
      title: 'Removendo sessão',
      message: 'Deseja realmente remover a sessão $sessionName?',
    );
  }

  Future<bool> confirmEraseTraining(BuildContext context) async {
    final result = await UIHelper.showBool(
        context: context,
        title: 'Apagar treino?',
        message: 'Deseja realmente sair sem salvar o treino?');
    return Future.value(result ?? false);
  }
}
