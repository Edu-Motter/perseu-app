import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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

          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: Text('Novo treino - ${widget.trainingName}'),
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: Palette.primary,
              animatedIcon: AnimatedIcons.menu_close,
              animatedIconTheme: const IconThemeData(size: 22.0),
              visible: true,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                  backgroundColor: Palette.accent,
                  foregroundColor: Colors.white,
                  labelBackgroundColor: Palette.accent,
                  child: const Icon(Icons.add),
                  onTap: () => goToSession(context, model),
                  label: 'Adicionar sessão',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SpeedDialChild(
                  backgroundColor: Palette.accent,
                  foregroundColor: Colors.white,
                  labelBackgroundColor: Palette.accent,
                  child: const Icon(Icons.forward),
                  onTap: () => {
                    if (model.training.sessions.isNotEmpty)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AthletesAssignTrainingScreen(
                              training: model.training),
                        ),
                      )
                    else
                      UIHelper.showError(
                          context,
                          const Result.error(
                              message: 'Não há sessões para serem atribuidas'))
                  },
                  label: 'Atribuir treino',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: model.training.sessions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Crie uma sessão de exercícios em "Adicionar sessão"'),
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
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: model.training.sessions.length,
                    itemBuilder: (context, index) {
                      SessionModel session = model.training.sessions[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          color: Colors.white,
                          child: ExpansionTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        model.training.sessions.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => NewSessionScreen(
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
}
