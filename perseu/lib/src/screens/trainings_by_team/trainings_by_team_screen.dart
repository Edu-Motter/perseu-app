import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/screens/training_details/training_details_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

import 'trainings_by_team_viewmodel.dart';

class TrainingsByTeamScreen extends StatelessWidget {
  const TrainingsByTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingsByTeamViewModel>(
      create: (_) => locator<TrainingsByTeamViewModel>(),
      child: Consumer<TrainingsByTeamViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Lista de treinos'),
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
                        return TrainingsList(trainings: result.data!);
                      }
                      if (result.success && result.data!.isEmpty) {
                        return const CenterError(
                            message: 'Não possui treinos ainda');
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

class TrainingsList extends StatelessWidget {
  const TrainingsList({
    Key? key,
    required this.trainings,
  }) : super(key: key);

  final List<TrainingByTeamDTO> trainings;

  static const Color buttonColor = Palette.secondary;
  static const Color textColor = Palette.primary;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTitle(text: 'Quantidade de treinos: ${trainings.length}'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final TrainingByTeamDTO training = trainings[index];
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    title: Text(
                      training.name,
                      style: const TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: buttonColor,
                      size: 28,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TrainingDetailsScreen(
                          trainingId: training.id,
                          trainingName: training.name,
                          showAssignTraining: true,
                        );
                      },
                    )),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
