import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import '../assign_training/assign_training_screen.dart';
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(children: [
                              const ListTitle(
                                text: 'Atletas e grupos disponíveis',
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: (model.athletes.length),
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
                              const SizedBox(height: 16)
                            ]),
                          );
                        } else {
                          return PerseuMessage.result(result);
                        }
                      }
                      return const PerseuMessage(
                          message: 'Ocorreu um problema ao carregar atletas');
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAssign(BuildContext context) async {
    final model =
        Provider.of<AthletesAssignTrainingViewModel>(context, listen: false);
    Result result = await model.assign(training, model.athletes);
    if (result.success) {
      Navigator.popUntil(context, (route) => route.isFirst);
      UIHelper.showSuccess(
        context,
        const Result.success(
          message: 'Treino criado e atribuído com successo',
        ),
      );
    } else {
      UIHelper.showError(context, result);
    }
  }
}
