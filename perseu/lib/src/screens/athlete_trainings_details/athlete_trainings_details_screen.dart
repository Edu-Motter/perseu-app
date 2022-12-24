import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/athlete_info_dto.dart';
import 'package:perseu/src/models/dtos/athlete_training_dto.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/training_details/training_details_screen.dart';
import 'package:perseu/src/screens/training_to_athlete/training_to_athlete_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

import 'athlete_trainings_details_viewmodel.dart';
import 'components/athlete_information_with_icons.dart';
import 'dart:math' as math;

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
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Atleta'),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Palette.accent,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(
                  Icons.reply_all,
                  color: Colors.white,
                ),
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
                          return const CircularLoading();
                      }
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: SliverDividerWithText(text: 'Treino atual:'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: model.getCurrentTraining(athleteId),
                    builder:
                        (context, AsyncSnapshot<Result<TrainingDTO>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const CircularLoading();
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            final result = snapshot.data!;
                            if (result.success) {
                              final currentTraining = result.data!;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text(
                                      currentTraining.name,
                                      style: const TextStyle(
                                        color: Palette.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward,
                                      color: Palette.secondary,
                                      size: 28,
                                    ),
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return TrainingDetailsScreen(
                                          trainingId: currentTraining.id,
                                          trainingName: currentTraining.name,
                                        );
                                      },
                                    )),
                                  ),
                                ),
                              );
                            } else {
                              if (ErrorType.notFound == result.errorType) {
                                return PerseuMessage(
                                  message: result.message ?? 'Não encontrado',
                                  icon: Icons.info,
                                );
                              }
                            }
                          }
                          return const NoFoundTrainingCard();
                      }
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder(
                    future: model.isJustOneTraining(athleteId),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const CircularLoading();
                        case ConnectionState.done:
                          if (snapshot.hasData && snapshot.data!) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: SliverDividerWithText(
                                text: 'Próximos treinos:',
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                      }
                    },
                  ),
                ),
                activeTrainingsList(context, model),
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

  Widget activeTrainingsList(
    BuildContext context,
    AthleteTrainingsDetailsViewModel model,
  ) {
    return FutureBuilder(
      future: model.getActiveTrainings(athleteId),
      builder: (
        context,
        AsyncSnapshot<Result<Object?>> snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const SliverToBoxAdapter(child: CircularLoading());
          case ConnectionState.done:
            if (snapshot.hasData) {
              final result = snapshot.data!;
              if (snapshot.data!.success) {
                final athleteTrainings =
                    result.data! as List<AthleteTrainingDTO>;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final activeTraining = athleteTrainings[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              activeTraining.training.name,
                              style: const TextStyle(
                                  color: Palette.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => UIHelper.showBoolDialog(
                                    context: context,
                                    title: 'Desativar treino',
                                    message:
                                        'Tem certeza que deseja desativar o treino ${activeTraining.training.name} para $athleteName?',
                                    onNoPressed: () => Navigator.pop(context),
                                    onYesPressed: () async {
                                      final navigator = Navigator.of(context);
                                      final result =
                                          await model.deactivateTraining(
                                              athleteId,
                                              activeTraining.training.id);
                                      if (result.success) {
                                        navigator.pop();
                                        model.notifyListeners();
                                        UIHelper.showSuccess(
                                            context,
                                            Result.success(
                                                message: result.data));
                                      } else {
                                        navigator.pop();
                                        UIHelper.showError(context, result);
                                      }
                                    },
                                  ),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Palette.secondary,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Palette.secondary,
                                  size: 28,
                                ),
                              ],
                            ),
                            onTap: () =>
                                Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TrainingDetailsScreen(
                                  trainingId: activeTraining.training.id,
                                  trainingName: activeTraining.training.name,
                                );
                              },
                            )),
                          ),
                        ),
                      );
                    },
                    childCount: athleteTrainings.length,
                  ),
                );
              }
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
      },
    );
  }
}

class SliverDividerWithText extends StatelessWidget {
  const SliverDividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Palette.primary,
            height: 1.5,
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              text,
              style: const TextStyle(
                color: Palette.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: Palette.primary,
            height: 1.5,
          )),
        ],
      ),
    );
  }
}

class NoFoundTrainingCard extends StatelessWidget {
  const NoFoundTrainingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Palette.primary,
      child: ListTile(
        title: Text(
          'Treino não encontrado',
          style: TextStyle(color: Palette.background),
        ),
        trailing: Icon(
          Icons.error_outline,
          color: Palette.background,
          size: 28,
        ),
      ),
    );
  }
}
