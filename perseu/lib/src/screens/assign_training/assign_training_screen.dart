import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/coach_assign_training/athletes_assign_training_viewmodel.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
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
                  backgroundColor: Palette.background,
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
                            return const CircularLoading();
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              Result result = snapshot.data as Result;
                              if (result.success) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const ListTitle(
                                            text: 'Atletas e grupos disponíveis'),
                                        Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: model.athletes.length,
                                            itemBuilder: (_, int index) {
                                              return AthleteCheckboxTile(
                                                athlete: model.athletes[index],
                                              );
                                            },
                                          ),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              _handleAssign(context);
                                            },
                                            child: const Text('Atribuir')),
                                        const SizedBox(height: 16),
                                      ]),
                                );
                              }
                              return PerseuMessage.result(result);
                            }
                            return const PerseuMessage(
                              message:
                                  'Consulta aos atletas não obteve retorno',
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
      Navigator.pop(context);
      Navigator.pop(context);
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
        checkColor: Palette.background,
        activeColor: Palette.primary,
        selectedTileColor: Palette.accent,
        title: _getTitle(
          isGroup: widget.athlete.isGroupOfAthletes,
          name: widget.athlete.name,
        ),
        value: widget.athlete.assigned,
        onChanged: (bool? checkboxState) {
          setState(() {
            widget.athlete.assigned = checkboxState ?? true;
          });
        });
  }

  Widget _getTitle({required bool isGroup, required String name}) {
    return Row(
      children: [
        Visibility(
          visible: isGroup,
          child: const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                'Grupo:',
                style: TextStyle(
                  color: Palette.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ),
        Visibility(
          visible: !isGroup,
          child: const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Text(
              'Atleta:',
              style: TextStyle(
                color: Palette.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(name, style: const TextStyle(color: Palette.primary)),
      ],
    );
  }
}
