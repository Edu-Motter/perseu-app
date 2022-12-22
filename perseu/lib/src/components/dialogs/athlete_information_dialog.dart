import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/athlete_info_dto.dart';
import 'package:perseu/src/services/clients/client_athlete.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/foundation.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

class AthleteInformationDialog extends StatelessWidget {
  const AthleteInformationDialog({
    Key? key,
    required this.athleteId,
  }) : super(key: key);

  final int athleteId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AthleteInformationViewModel>(),
      child: Consumer<AthleteInformationViewModel>(
        builder: (context, model, child) {
          return AlertDialog(
            title: const Text(
              'Informações do Atleta',
              style: TextStyle(
                color: Palette.primary,
                fontWeight: FontWeight.bold
              ),
            ),
            content: FutureBuilder(
              future: model.getAthleteInfo(athleteId),
              builder:
                  (context, AsyncSnapshot<Result<AthleteInfoDTO>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return AthleteInformation(athlete: snapshot.data!.data!);
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
          );
        },
      ),
    );
  }
}

class AthleteInformation extends StatelessWidget {
  const AthleteInformation({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  final AthleteInfoDTO athlete;

  @override
  Widget build(BuildContext context) {
    final formattedCpf = Formatters.cpf().maskText(athlete.document);
    final formattedDate = DateFormatters.toDateString(athlete.birthdate);
    final formattedHeight =
        Formatters.height().maskText(athlete.height.toString());
    final formattedWeight =
        Formatters.weight().maskText(athlete.weight.toString());

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InformationLine(label: 'Nome', text: athlete.name),
        const Divider(),
        InformationLine(label: 'CPF', text: formattedCpf),
        const Divider(),
        InformationLine(label: 'Data de nascimento', text: formattedDate),
        const Divider(),
        InformationLine(label: 'Altura', text: '$formattedHeight m'),
        const Divider(),
        InformationLine(label: 'Peso', text: '$formattedWeight Kg'),
      ],
    );
  }
}

class InformationLine extends StatelessWidget {
  const InformationLine({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Palette.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class AthleteInformationViewModel extends AppViewModel {
  final clientAthlete = locator<ClientAthlete>();

  Future<Result<AthleteInfoDTO>> getAthleteInfo(int athleteId) async {
    final result =
        await clientAthlete.getAthlete(athleteId, session.authToken!);
    if (result.success) {
      return Result.success(data: AthleteInfoDTO.fromJson(result.data));
    }
    return Result.error(message: result.message);
  }
}
