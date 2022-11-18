import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_screen.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/components/widgets/center_rounded_container.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:provider/provider.dart';

import 'manage_athletes_viewmodel.dart';

class ManageAthletesScreen extends StatelessWidget {
  const ManageAthletesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ManageAthletesViewModel>(
      create: (_) => locator<ManageAthletesViewModel>(),
      child: Consumer<ManageAthletesViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gerenciar Atletas'),
            ),
            body: FutureBuilder(
              future: model.getAthletes(),
              builder: (
                context,
                AsyncSnapshot<Result<List<AthleteDTO>>> snapshot,
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
                        return AthletesList(athletes: result.data!);
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
