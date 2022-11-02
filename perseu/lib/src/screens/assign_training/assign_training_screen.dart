import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_viewmodel.dart';
import 'package:perseu/src/screens/widgets/center_error.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'assign_training_viewmodel.dart';

class AssignTrainingScreen extends StatefulWidget {
  const AssignTrainingScreen({Key? key, required this.training})
      : super(key: key);
  final TrainingDTO training;

  @override
  _AssignTrainingState createState() => _AssignTrainingState();
}

class _AssignTrainingState extends State<AssignTrainingScreen> {
  @override
  void initState() {
    // training = widget.training;
    super.initState();
  }

  final bool checkboxState = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => locator<AssignTrainingViewModel>(),
        child: Consumer<AssignTrainingViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: model.isBusy,
              child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      _handleAssign(context);
                    },
                    child: const Icon(Icons.send),
                  ),
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
                            if (snapshot.hasData) {
                              Result result = snapshot.data as Result;
                              if (result.success) {
                                return ListView(
                                    padding: const EdgeInsets.all(16.0),
                                    children: [
                                      const Text('Atletas'),
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
                                      ElevatedButton(
                                          onPressed: () async {
                                            _handleAssign(context);
                                          },
                                          child: const Text('Atribuir'))
                                    ]);
                              }
                              return CenterError(
                                  message: result.message ??
                                      'Erro ao carregar atletas');
                            }
                            return const Center(
                              child: Text(
                                  'Consulta aos atletas não obteve retorno'),
                            );
                        }
                      })),
            );
          },
        ));
  }

  void _handleAssign(BuildContext context) async {
    final model = Provider.of<AssignTrainingViewModel>(context, listen: false);
    Result result = await model.assign(widget.training, model.athletes);
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
        title: Text(widget.athlete.athleteName),
        value: widget.athlete.assigned,
        onChanged: (bool? checkboxState) {
          setState(() {
            widget.athlete.assigned = checkboxState ?? true;
          });
        });
  }
}
