import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/dtos/exercise_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/assign_training/assign_training_screen.dart';
import 'package:perseu/src/screens/athlete_trainings_details/components/athlete_information_with_icons.dart';
import 'package:perseu/src/screens/training_details/training_details_viewmodel.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

class TrainingDetailsScreen extends StatelessWidget {
  const TrainingDetailsScreen({
    Key? key,
    required this.trainingId,
    required this.trainingName,
    this.showAssignTraining = false,
    this.dateTimeCheck,
    this.effort,
  }) : super(key: key);

  final int trainingId;
  final String trainingName;
  final bool showAssignTraining;
  final String? dateTimeCheck;
  final int? effort;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingDetailsViewModel>(
      create: (_) => locator<TrainingDetailsViewModel>(),
      child: Consumer<TrainingDetailsViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(trainingName),
            ),
            floatingActionButton: showAssignTraining
                ? SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'Atribuir treino',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(Icons.assignment_ind),
                        ],
                      ),
                      onPressed: () => _handleAssignTraining(context, model),
                    ),
                  )
                : const SizedBox.shrink(),
            body: Column(
              children: [
                if (dateTimeCheck != null && effort != null)
                  CheckDetails(dateTimeCheck: dateTimeCheck!, effort: effort!),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
                    child: FutureBuilder(
                      future: model.getTraining(trainingId),
                      builder: (context,
                          AsyncSnapshot<Result<TrainingDTO>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasData) {
                              final result = snapshot.data!;
                              if (result.success) {
                                return TrainingView(training: result.data!);
                              }
                            }
                            return const CenterError(
                                message: 'Problema ao carregar treino');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleAssignTraining(
      BuildContext context, TrainingDetailsViewModel model) {
    if (model.training != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssignTrainingScreen(training: model.training!),
        ),
      );
    } else {
      UIHelper.showFlashNotification(context, 'Treino ainda não carregado');
    }
  }
}

class CheckDetails extends StatelessWidget {
  const CheckDetails({
    Key? key,
    required this.dateTimeCheck,
    required this.effort,
  }) : super(key: key);

  final String dateTimeCheck;
  final int effort;

  static const backgroundColor = Colors.white;
  static const foregroundColor = Colors.teal;

  static const standardStyle = TextStyle(color: foregroundColor, fontSize: 16);
  static const standardStyleBold = TextStyle(
      color: foregroundColor, fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormatters.toDateTimeString(dateTimeCheck);
    final formattedEffort = Formatters.effortFormatter(effort);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: foregroundColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.today,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Realizado: ',
                    style: standardStyleBold,
                  ),
                  Text(formattedDate, style: standardStyle),
                ],
              ),
              const InfoDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.circle,
                    color: backgroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Feedback: ',
                    style: standardStyleBold,
                  ),
                  Text(formattedEffort, style: standardStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrainingView extends StatelessWidget {
  const TrainingView({Key? key, required this.training}) : super(key: key);

  final TrainingDTO training;

  @override
  Widget build(BuildContext context) {
    final sessions = training.sessions!;

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return Card(
          child: ExpansionTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.keyboard_arrow_down),
                )
              ],
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            title: Text(sessions[index].name),
            children: [
              for (ExerciseDTO e in sessions[index].exercises!)
                ExerciseCard(
                  name: e.name,
                  description: e.description,
                )
            ],
          ),
        );
      },
    );
  }
}
