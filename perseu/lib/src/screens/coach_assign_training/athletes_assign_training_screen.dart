import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/style.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'athletes_assign_training_viewmodel.dart';

class AthletesAssignTrainingScreen extends StatefulWidget {
  const AthletesAssignTrainingScreen({Key? key, required this.training})
      : super(key: key);
  final TrainingModel training;

  @override
  _AssignTrainingState createState() => _AssignTrainingState();
}

class _AssignTrainingState extends State<AthletesAssignTrainingScreen> {
  late AthletesToAssignTrainingModel athletesToAssignTrainingModel;
  late TrainingModel training;
  @override
  void initState() {
    training = widget.training;
    super.initState();
  }

  final bool checkboxState = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<AthletesAssignTrainingViewModel>(),
        child: Consumer<AthletesAssignTrainingViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: model.isBusy,
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Atribuir treino'),
                  ),
                  body: FutureBuilder(
                      future: model.getAthletes(),
                      builder: (context, AsyncSnapshot<Result> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.done:
                            Result result = snapshot.data as Result;
                            if (result.success) {
                              return ListView(
                                  padding: const EdgeInsets.all(16.0),
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Atletas disponíveis',
                                        style: TextStyle(
                                            color: Style.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: model.athletes.length,
                                      itemBuilder: (_, int index) {
                                        return AthleteCheckboxTile(
                                          athlete: model.athletes[index],
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          _handleAssign(context);
                                        },
                                        child: const Text('Atribuir'))
                                  ]);
                            } else {
                              return const Center(
                                child: Text('Erro ao carregar atletas'),
                              );
                            }
                        }
                      })),
            );
          },
        ));
  }

  void _handleAssign(BuildContext context) async {
    final model =
        Provider.of<AthletesAssignTrainingViewModel>(context, listen: false);
    Result result = await model.assign(training, model.athletes);
    if (result.success) {
      UIHelper.showSuccess(context, result);
    } else {
      UIHelper.showError(context, result);
    }
  }
}

class AthleteCheckboxTile extends StatefulWidget {
  const AthleteCheckboxTile({Key? key, required this.athlete})
      : super(key: key);

  final AthletesToAssignTrainingModel athlete;

  @override
  State<AthleteCheckboxTile> createState() => _AthleteCheckboxTileState();
}

class _AthleteCheckboxTileState extends State<AthleteCheckboxTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        checkColor: Style.background,
        activeColor: Style.primary,
        selectedTileColor: Style.accent,
        title: Text(
          widget.athlete.athleteName,
          style: const TextStyle(color: Style.primary),
        ),
        value: widget.athlete.assigned,
        onChanged: (bool? checkboxState) {
          setState(() {
            widget.athlete.assigned = checkboxState ?? true;
          });
        });
  }
}
