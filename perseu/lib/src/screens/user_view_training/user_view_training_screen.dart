import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/dialogs/checkin_dialog/checkin_dialog.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/user_view_training/user_view_training_viewmodel.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

class UserViewTrainingScreen extends StatefulWidget {
  const UserViewTrainingScreen({Key? key}) : super(key: key);

  @override
  State<UserViewTrainingScreen> createState() => _UserViewTrainingScreenState();
}

class _UserViewTrainingScreenState extends State<UserViewTrainingScreen> {
  late TrainingModel training;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const defaultPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingViewModel>(
      create: (_) => locator<TrainingViewModel>(),
      child: Consumer<TrainingViewModel>(
        builder: (__, model, _) {
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
                backgroundColor: Palette.background,
                key: _scaffoldKey,
                appBar: AppBar(
                  title: const Text('Treino atribuído'),
                ),
                body: Column(children: [
                  Flexible(
                    child: FutureBuilder(
                      future: model.getTraining(),
                      builder: (context,
                          AsyncSnapshot<Result<TrainingDTO>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const CircularLoading();
                          case ConnectionState.done:
                            if (snapshot.hasData &&
                                snapshot.data!.data != null) {
                              final result = snapshot.data!.data!;
                              final training = TrainingModel(
                                  name: result.name,
                                  id: result.id,
                                  sessions: result.sessions!
                                      .map((s) => SessionModel(
                                          id: s.id,
                                          name: s.name,
                                          exercises: s.exercises!
                                              .map((e) => ExerciseModel(
                                                  id: e.id,
                                                  name: e.name,
                                                  description: e.description))
                                              .toList()))
                                      .toList());
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    training.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Palette.primary, fontSize: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  const AccentDivider(
                                      dividerPadding: defaultPadding),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: training.sessions.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            margin: const EdgeInsets.only(
                                                top: defaultPadding),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            color: Colors.white,
                                            child: ExpansionTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons
                                                        .keyboard_arrow_down),
                                                  )
                                                ],
                                              ),
                                              expandedCrossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              title: Text(
                                                training.sessions[index].name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Palette.primary,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              children: [
                                                for (ExerciseModel e in training
                                                    .sessions[index].exercises)
                                                  ExerciseCard(
                                                    name: e.name,
                                                    description: e.description,
                                                  )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: defaultPadding,
                                        right: defaultPadding,
                                        bottom: defaultPadding),
                                    child: ElevatedButton(
                                      child: const Text('Check in'),
                                      onPressed: () => _handleCheckIn(
                                          context, training.id, model),
                                    ),
                                  ),
                                ],
                              );
                              // return Text(snapshot.data!.data!.createdAt);
                            } else {
                              return const Center(
                                child: Text('Nenhum treino atribuído'),
                              );
                            }
                        }
                      },
                    ),
                  ),
                ])),
          );
        },
      ),
    );
  }

  void _handleCheckIn(
    BuildContext context,
    int trainingId,
    TrainingViewModel model,
  ) {
    showDialog(
      context: context,
      builder: (context) => CheckInDialog(
        trainingId: trainingId,
      ),
    );
  }
}
