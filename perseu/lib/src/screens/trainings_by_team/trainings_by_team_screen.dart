import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_by_team_dto.dart';
import 'package:perseu/src/screens/training_details/training_details_screen.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/components/widgets/center_rounded_container.dart';
import 'package:perseu/src/services/foundation.dart';
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
                'Quantidade de treinos: ${trainings.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: trainings.length,
              itemBuilder: (context, index) {
                final TrainingByTeamDTO training = trainings[index];
                return Card(
                  child: ListTile(
                    title: Text(training.name),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.teal,
                      size: 28,
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TrainingDetailsScreen(
                          trainingId: training.id,
                          trainingName: training.name,
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
