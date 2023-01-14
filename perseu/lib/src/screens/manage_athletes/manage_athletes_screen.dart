import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/screens/athlete_trainings_details/athlete_trainings_details_screen.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
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

class AthletesList extends StatelessWidget {
  const AthletesList({
    Key? key,
    required this.athletes,
  }) : super(key: key);

  final List<AthleteDTO> athletes;

  static const buttonColor = Palette.secondary;
  static const textColor = Palette.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTitle(text: 'Quantidade de atletas: ${athletes.length}'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: athletes.length,
              itemBuilder: (context, index) {
                final AthleteDTO athlete = athletes[index];
                return Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    title: Text(
                      athlete.name,
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
        ),
      ],
    );
  }
}

///TODO!: Colocar como componente gerenerico
class ListTitle extends StatelessWidget {
  const ListTitle({
    Key? key,
    required this.text,
    this.dividerPadding = 8,
    this.topPadding = 21,
  }) : super(key: key);

  final String text;
  final double dividerPadding;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 16, top: topPadding),
          child: Text(
            text,
            style: const TextStyle(
              color: Palette.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        AccentDivider(dividerPadding: dividerPadding),
      ],
    );
  }
}

class AccentDivider extends StatelessWidget {
  const AccentDivider({
    Key? key,
    this.dividerPadding = 8,
    this.accentColor = Palette.accent,
    this.height = 4,
  }) : super(key: key);

  final double dividerPadding;
  final double height;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dividerPadding),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            color: accentColor, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
