import 'package:flutter/material.dart';
import 'package:perseu/src/models/training_model.dart';

import 'assign_training_viewmodel.dart';

class AssignTrainingScreen extends StatefulWidget {
  const AssignTrainingScreen({Key? key, required this.training})
      : super(key: key);
  final TrainingModel training;

  @override
  _AssignTrainingState createState() => _AssignTrainingState();
}

class _AssignTrainingState extends State<AssignTrainingScreen> {
  late AthletesToAssignTrainingModel athletesToAssignTrainingModel;
  late TrainingModel training;
  @override
  void initState() {
    training = widget.training;
    super.initState();
  }

  List<AthletesToAssignTrainingModel> athletesToAssign = [
    AthletesToAssignTrainingModel(
        athleteName: "Rafael", athleteId: 0, assigned: false),
    AthletesToAssignTrainingModel(
        athleteName: "José", athleteId: 1, assigned: false),
    AthletesToAssignTrainingModel(
        athleteName: "Bianca", athleteId: 2, assigned: false),
  ];

  final bool checkboxState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atribuir treino'),
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: [
          const Text("Atletas"),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: athletesToAssign.length,
            itemBuilder: (_, int index) {
              return CheckboxListTile(
                  title: Text(athletesToAssign[index].athleteName),
                  value: athletesToAssign[index].assigned,
                  onChanged: (bool? checkboxState) {
                    setState(() {
                      athletesToAssign[index].assigned = checkboxState ?? true;
                    });
                  });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () async {
                if (athletesToAssign.any((element) => element.assigned)) {
                  AssignTrainingModel assignTrainingModel = AssignTrainingModel(
                      training: training,
                      athletes: athletesToAssign
                          .where((AthletesToAssignTrainingModel athlete) =>
                              athlete.assigned)
                          .toList());
                  await assignTrainingModel.assign();
                  debugPrint(assignTrainingModel.athletes[0].athleteName);
                  debugPrint(assignTrainingModel.training.name);
                } else {
                  debugPrint('Selecione ao menos um atleta');
                }
              },
              child: const Text('Atribuir'))
        ]));
  }
}
