import 'package:flutter/material.dart';
import 'package:perseu/src/components/session_data/session_data.dart';
import 'package:perseu/src/models/exercise_model.dart';
import 'package:perseu/src/models/sessions_model.dart';
import 'package:perseu/src/viewModels/training_list_view_model.dart';

class TrainingSessionList extends StatefulWidget {
  const TrainingSessionList({Key? key}) : super(key: key);

  @override
  TrainingSessionListState createState() => TrainingSessionListState();
}

class TrainingSessionListState extends State<TrainingSessionList> {
  SessionModel session = SessionModel(id: 1, name: 'nome sesão', exercises: [
    ExerciseModel(id: 1, name: 'exercício top', description: 'descrição top'),
    ExerciseModel(
        id: 1, name: 'exercício top 2', description: 'mais cansado nessa')
  ]);
  final List<TrainingCard> _data = generateItems(3);
  final List<ExerciseItem> items = generateExercises([
    ExerciseModel(id: 1, name: 'exercício top', description: 'descrição top'),
    ExerciseModel(
        id: 1, name: 'exercício top 2', description: 'mais cansado nessa')
  ]);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((TrainingCard item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      title: item.buildTitle(context),
                      subtitle: item.buildSubtitle(context),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const IconButton(onPressed: null, icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _data.removeWhere(
                                (currentItem) => item == currentItem);
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ),
              ]),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

List<TrainingCard> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return TrainingCard(
      headerValue: 'Sessão #$index',
      expandedValue: 'Exercicios $index',
      isExpanded: false,
    );
  });
}

List<ExerciseItem> generateExercises(List<ExerciseModel> exerciseList) {
  return List<ExerciseItem>.generate(
    exerciseList.length,
    (i) => Exercise(exerciseList[i].name, exerciseList[i].description),
  );
}
