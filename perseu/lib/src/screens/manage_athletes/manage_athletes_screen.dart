import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
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
            backgroundColor: Palette.background,
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
          ListTitle(text: 'Quantidade de atletas: ${athletes.length}'),
          Expanded(
            child: ListView.builder(
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final AthleteDTO athlete = athletes[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      athlete.name,
                      style: const TextStyle(
                          color: Palette.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
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

///TODO!: Colocar como componente gerenerico
class ListTitle extends StatelessWidget {
  const ListTitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 21),
          child: Text(
            text,
            style: const TextStyle(
              color: Palette.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: double.infinity,
            height: 4,
            decoration: BoxDecoration(
                color: Palette.accent, borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
