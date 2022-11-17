import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_info_dto.dart';
import 'package:perseu/src/screens/training_details/training_details_screen.dart';
import 'package:perseu/src/screens/training_to_athlete/training_to_athlete_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:provider/provider.dart';

import 'athlete_trainings_details_viewmodel.dart';

class AthleteTrainingsDetailsScreen extends StatelessWidget {
  const AthleteTrainingsDetailsScreen({
    Key? key,
    required this.athleteId,
    required this.athleteName,
  }) : super(key: key);

  final int athleteId;
  final String athleteName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AthleteTrainingsDetailsViewModel>(
      create: (_) => locator<AthleteTrainingsDetailsViewModel>(),
      child: Consumer<AthleteTrainingsDetailsViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(athleteName),
            ),
            floatingActionButton: SizedBox(
              width: 140,
              child: ElevatedButton(
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Novo treino',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(Icons.assignment_ind),
                  ],
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingToAthleteScreen(
                      athleteName: athleteName,
                      athleteId: athleteId,
                    ),
                  ),
                ),
              ),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: model.getAthleteInfo(athleteId),
                    builder: (context,
                        AsyncSnapshot<Result<AthleteInfoDTO>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            return AthleteInformationWithIcons(
                                athlete: snapshot.data!.data!);
                          } else {
                            return const Center(
                              child: Text('Falha ao carregar dados do usuário'),
                            );
                          }
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                      }
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    color: Colors.teal,
                    child: ListTile(
                      title: const Text(
                        'Active Training',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 28,
                      ),
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const TrainingDetailsScreen(
                            trainingId: 1,
                            trainingName: 'Active Training',
                          );
                        },
                      )),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Card(
                      color: Colors.teal,
                      child: ListTile(
                        title: const Text(
                          'Assigned Training',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 28,
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const TrainingDetailsScreen(
                              trainingId: 1,
                              trainingName: 'Assigned Training',
                            );
                          },
                        )),
                      ),
                    );
                  }, childCount: 5),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 75,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class AthleteInformationWithIcons extends StatelessWidget {
  const AthleteInformationWithIcons({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  static const standardStyle = TextStyle(color: Colors.white, fontSize: 16);
  static const standardStyleBold =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  final AthleteInfoDTO athlete;
  @override
  Widget build(BuildContext context) {
    final formattedCpf = Formatters.cpf().maskText(athlete.document);
    final formattedDate = DateFormatters.toDateString(athlete.birthdate);
    final formattedHeight =
        Formatters.height().maskText(athlete.height.toString());
    final formattedWeight =
        Formatters.weight().maskText(athlete.weight.toString());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Nome: ',
                    style: standardStyleBold,
                  ),
                  Text(athlete.name, style: standardStyle),
                ],
              ),
              const Divider(color: Colors.white54,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'CPF: ',
                    style: standardStyleBold,
                  ),
                  Text(formattedCpf, style: standardStyle),
                ],
              ),
              const Divider(color: Colors.white54,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cake,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Data de nascimento: ',
                    style: standardStyleBold,
                  ),
                  Text(formattedDate, style: standardStyle),
                ],
              ),
              const Divider(color: Colors.white54,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.height,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Altura: ',
                    style: standardStyleBold,
                  ),
                  Text('$formattedHeight m', style: standardStyle),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Peso: ',
                    style: standardStyleBold,
                  ),
                  Text('$formattedWeight Kg', style: standardStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
