import 'package:flutter/material.dart';

import 'assign_training_viewmodel.dart';

class AssignTrainingScreen extends StatefulWidget {
  const AssignTrainingScreen({Key? key}) : super(key: key);
  @override
  _AssignTrainingState createState() => _AssignTrainingState();
}

class _AssignTrainingState extends State<AssignTrainingScreen> {
  late AssignTrainingModel assignTrainingModel;
  @override
  void initState() {
    super.initState();
  }

  List<AssignTrainingModel> athletesToAssign = [
    AssignTrainingModel(athleteName: "Rafael", athleteId: 0, assigned: false),
    AssignTrainingModel(athleteName: "José", athleteId: 1, assigned: false),
    AssignTrainingModel(athleteName: "Bianca", athleteId: 2, assigned: false),
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
          ElevatedButton(onPressed: () {}, child: const Text('Atribuir'))
        ]));
  }
}
