import 'package:flutter/material.dart';

import 'assign_training_viewmodel.dart';

class AssignTrainingScreen extends StatefulWidget {
  const AssignTrainingScreen({Key? key, this.assignTrainingModel})
      : super(key: key);

  final AssignTrainingModel? assignTrainingModel;
  @override
  _AssignTrainingState createState() => _AssignTrainingState();
}

class _AssignTrainingState extends State<AssignTrainingScreen> {
  late AssignTrainingModel assignTrainingModel;
  @override
  void initState() {
    assignTrainingModel =
        AssignTrainingModel(athleteName: "Zeca", athleteId: 0, assigned: false);
    super.initState();
  }

  final bool checkboxState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Atribuir treino'),
        ),
        body: ListView(padding: const EdgeInsets.all(16.0), children: [
          const Text("Atletas"),
          CheckboxListTile(
              title: Text(assignTrainingModel.athleteName),
              value: assignTrainingModel.assigned,
              onChanged: (bool? checkboxState) {
                setState(() {
                  assignTrainingModel.assigned = checkboxState ?? true;
                });
              }),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {},
              child: const Text('Atribuir'))
        ]));
  }
}
