import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/training_dto.dart';
// import 'package:perseu/src/components/exercise_card/exercise_card.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/models/training_model.dart';
import 'package:perseu/src/screens/user_view_training/user_view_training_viewmodel.dart';
import 'package:provider/provider.dart';

class UserViewTrainingScreen extends StatefulWidget {
  const UserViewTrainingScreen({Key? key}) : super(key: key);

  @override
  State<UserViewTrainingScreen> createState() => _UserViewTrainingScreenState();
}

class _UserViewTrainingScreenState extends State<UserViewTrainingScreen> {
  late TrainingModel training;
  @override
  void initState() {
    training = TrainingModel(id: 1, name: 'treino forte', sessions: [
      SessionModel(
        id: 0,
        name: 'Aquecimento',
        exercises: [
          ExerciseModel(
              id: '0',
              name: 'Alongamento leve',
              description:
                  'Alongar articulações das pernas e braços por 10 segundos'),
          ExerciseModel(
              id: '1',
              name: 'Corrida',
              description: 'Trote na pista, de 8 a 10 minutos')
        ],
      ),
      SessionModel(id: 1, name: 'Exercício pernas', exercises: [
        ExerciseModel(
            id: '0',
            name: 'Leg press',
            description: 'Fazer leg press 45 com 140kg, 3x10'),
        ExerciseModel(
            id: '1',
            name: 'Leg press',
            description: 'Fazer leg press 45 com 140kg, 3x10'),
      ])
    ]);

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TrainingViewModel>(
      create: (_) => locator<TrainingViewModel>(),
      child: Consumer<TrainingViewModel>(
        builder: (__, model, _) {
          // TrainingDTO training = model.training;
          // print('chegou $training');
          return ModalProgressHUD(
            inAsyncCall: model.isBusy,
            child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: const Text('Solicitações'),
                ),
                body: Column(children: [
                  const Divider(),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8, right: 16, left: 16),
                      child: FutureBuilder(
                        future: model.getTraining(10),
                        builder: (context, snapshot) {
                          print(model);
                          if (model.isBusy) {
                            return const Center(child: Text('sim'));
                          } else {
                            print(model.trainingInfo);
                            return const Center(
                                child:
                                    Text('Não existem treinos ainda'));
                          }
                        },
                      ),
                    ),
                  ),
                ])),
          );
        },
      ),
    );
  }
}
