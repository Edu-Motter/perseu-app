import 'package:flutter/material.dart';
import 'package:perseu/src/models/dtos/athlete_info_dto.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/formatters.dart';
import 'package:perseu/src/utils/style.dart';

class AthleteInformationWithIcons extends StatelessWidget {
  const AthleteInformationWithIcons({
    Key? key,
    required this.athlete,
  }) : super(key: key);

  static const backgroundColor = Colors.white;
  static const foregroundColor = Style.primary;

  static const standardStyle = TextStyle(color: foregroundColor, fontSize: 16);
  static const standardStyleBold = TextStyle(
      color: foregroundColor, fontSize: 16, fontWeight: FontWeight.bold);

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
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: foregroundColor, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_outline,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  // const Text(
                  //   'Nome: ',
                  //   style: standardStyleBold,
                  // ),
                  Text(athlete.name, style: standardStyle),
                ],
              ),
              const InfoDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  // const Text(
                  //   'CPF: ',
                  //   style: standardStyleBold,
                  // ),
                  Text(formattedCpf, style: standardStyle),
                ],
              ),
              const InfoDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.cake_outlined,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  // const Text(
                  //   'Data de nascimento: ',
                  //   style: standardStyleBold,
                  // ),
                  Text(formattedDate, style: standardStyle),
                ],
              ),
              const InfoDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.height_outlined,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  // const Text(
                  //   'Altura: ',
                  //   style: standardStyleBold,
                  // ),
                  Text('$formattedHeight m', style: standardStyle),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.fitness_center_outlined,
                    color: foregroundColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  // const Text(
                  //   'Peso: ',
                  //   style: standardStyleBold,
                  // ),
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

class InfoDivider extends StatelessWidget {
  const InfoDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Style.primary,
      thickness: 2,
    );
  }
}
