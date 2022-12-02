import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_screen.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/components/widgets/center_rounded_container.dart';
import 'package:perseu/src/services/foundation.dart';
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 36.0,
                                    vertical: 18.0,
                                  ),
                                  child: CenterRoundedContainer(
                                    child: Text(
                                      'Escolha o treino para $athleteName',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
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
                        return const CenterError(
                            message: 'Não possui atletas ainda');
                      }
                    }
                    return const CenterError(message: 'Erro desconhecido');
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
            title: Text(training.name),
            trailing: const Icon(
              Icons.note_add,
              color: Colors.teal,
              size: 28,
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
                  navigator.pop();
                  UIHelper.showSuccess(context, result);
                } else {
                  navigator.pop();
                  UIHelper.showError(context, result);
                }
              },
            ),
          ),
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
                  color: Colors.white,
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
                      color: Colors.teal,
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
