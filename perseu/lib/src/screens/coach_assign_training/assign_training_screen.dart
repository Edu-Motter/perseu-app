import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:provider/provider.dart';
import 'package:perseu/src/app/locator.dart';

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
    return ChangeNotifierProvider(
        create: (_) => locator<AssignTrainingViewModel>(),
        child: Consumer<AssignTrainingViewModel>(
          builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: model.isBusy,
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Atribuir treino'),
                  ),
                  body: FutureBuilder(
                      future: model.getAthletes(),
                      builder: (context, AsyncSnapshot<Result> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.done:
                            Result result = snapshot.data as Result;
                            List<AthleteDTO> athletes = result.data;
                            List<AthletesToAssignTrainingModel>
                                athletesToAssigns = athletes
                                    .map((i) => AthletesToAssignTrainingModel(
                                        athleteName: i.name,
                                        athleteId: i.id,
                                        assigned: false))
                                    .toList();
                            return ListView(
                                padding: const EdgeInsets.all(16.0),
                                children: [
                                  const Text("Atletas"),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: athletes.length,
                                    itemBuilder: (_, int index) {
                                      return CheckboxListTile(
                                          title: Text(athletes[index].name),
                                          value:
                                              athletesToAssign[index].assigned,
                                          onChanged: (bool? checkboxState) {
                                            setState(() {
                                              athletesToAssign[index].assigned =
                                                  checkboxState ?? true;
                                            });
                                          });
                                    },
                                  ),
                                ]);
                        }
                      }
                      // children: [
                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: athletesToAssign.length,
                      //     itemBuilder: (context, index) {
                      //       return CheckboxListTile(
                      //         title: Text(athletesToAssign[index].athleteName),
                      //         value: athletesToAssign[index].assigned,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             athletesToAssign[index].assigned = value!;
                      //           });
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     value.assign();
                      //   },
                      //   child: const Text('Atribuir'),
                      // ),
                      // ],
                      )),
            );
          },
        ));
    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Atribuir treino'),
    //     ),
    //     body: ListView(padding: const EdgeInsets.all(16.0), children: [
    //       const Text("Atletas"),
    //       ListView.builder(
    //         scrollDirection: Axis.vertical,
    //         shrinkWrap: true,
    //         itemCount: athletesToAssign.length,
    //         itemBuilder: (_, int index) {
    //           return CheckboxListTile(
    //               title: Text(athletesToAssign[index].athleteName),
    //               value: athletesToAssign[index].assigned,
    //               onChanged: (bool? checkboxState) {
    //                 setState(() {
    //                   athletesToAssign[index].assigned = checkboxState ?? true;
    //                 });
    //               });
    //         },
    //       ),
    //       const SizedBox(
    //         height: 16,
    //       ),
    //       ElevatedButton(
    //           onPressed: () async {
    //             if (athletesToAssign.any((element) => element.assigned)) {
    //               AssignTrainingViewModel assignTrainingModel =
    //                   AssignTrainingViewModel(
    //                       training: training,
    //                       athletes: athletesToAssign
    //                           .where((AthletesToAssignTrainingModel athlete) =>
    //                               athlete.assigned)
    //                           .toList());
    //               await assignTrainingModel.assign();
    //             } else {
    //               debugPrint('Selecione ao menos um atleta');
    //             }
    //           },
    //           child: const Text('Atribuir'))
    //     ]));
  }
}
