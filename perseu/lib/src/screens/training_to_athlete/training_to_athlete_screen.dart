import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/components/widgets/center_rounded_container.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_screen.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'training_to_athlete_viewmodel.dart';

class TrainingToAthleteScreen extends StatelessWidget {
  const TrainingToAthleteScreen({
    Key? key,
    required this.athleteName,
    required this.athleteId,
  }) : super(key: key);

  final String athleteName;
  final int athleteId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingToAthleteViewModel>(
      create: (_) => locator<TrainingToAthleteViewModel>(),
      child: Consumer<TrainingToAthleteViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Selecione o treino'),
            ),
            body: FutureBuilder(
              future: model.getTrainings(),
              builder: (
                context,
                AsyncSnapshot<Result<List<TrainingByTeamDTO>>> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final result = snapshot.data!;
                      if (result.success && result.data!.isNotEmpty) {
                        final Result<List<TrainingByTeamDTO>> result =
                            snapshot.data!;
                        if (result.success && result.data!.isNotEmpty) {
                          final List<TrainingByTeamDTO> trainings =
                              result.data!;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                ListTitle(
                                  text: 'Treino para $athleteName',
                                ),
                                Expanded(
                                  child: TrainingsListToAssign(
                                    trainings: trainings,
                                    athleteId: athleteId,
                                    athleteName: athleteName,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      if (result.success && result.data!.isEmpty) {
                        return const PerseuMessage(
                            message: 'Não possui atletas ainda');
                      }
                      return PerseuMessage.result(result);
                    }
                    return PerseuMessage.defaultError();
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class TrainingsListToAssign extends StatelessWidget {
  const TrainingsListToAssign({
    Key? key,
    required this.trainings,
    required this.athleteId,
    required this.athleteName,
  }) : super(key: key);

  final List<TrainingByTeamDTO> trainings;
  final String athleteName;
  final int athleteId;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TrainingToAthleteViewModel>(context);

    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final TrainingByTeamDTO training = trainings[index];
        return Card(
          child: ListTile(
              title: Text(
                training.name,
                style: const TextStyle(
                  color: Palette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(
                  Icons.reply,
                  color: Palette.secondary,
                ),
              ),
              onTap: () => UIHelper.showBoolDialog(
                    context: context,
                    title: 'Atribuindo Treino',
                    message:
                        'Tem certeza que deseja atribuir o treino ${training.name} para $athleteName?',
                    onNoPressed: () => Navigator.pop(context),
                    onYesPressed: () async {
                      final navigator = Navigator.of(context);
                      final result =
                          await model.assignTraining(athleteId, training.id);
                      if (result.success) {
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => AthleteTrainingsDetailsScreen(
                                athleteId: athleteId, athleteName: athleteName),
                          ),
                          (route) {
                            return route.settings.name == 'coach-home';
                          },
                        );
                        UIHelper.showSuccess(context, result);
                      } else {
                        navigator.pop();
                        UIHelper.showError(context, result);
                      }
                    },
                  )),
        );
      },
    );
  }
}

class AthletesList extends StatelessWidget {
  const AthletesList({
    Key? key,
    required this.athletes,
  }) : super(key: key);

  final List<AthleteDTO> athletes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 36.0,
              vertical: 18.0,
            ),
            child: CenterRoundedContainer(
              child: Text(
                'Quantidade de atletas: ${athletes.length}',
                style: const TextStyle(
                  color: Palette.background,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final AthleteDTO athlete = athletes[index];
                return Card(
                  child: ListTile(
                    title: Text(athlete.name),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Palette.primary,
                      size: 28,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AthleteTrainingsDetailsScreen(
                          athleteId: athlete.id,
                          athleteName: athlete.name,
                        );
                      },
                    )),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
