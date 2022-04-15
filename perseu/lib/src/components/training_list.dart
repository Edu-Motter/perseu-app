import 'package:flutter/material.dart';
import 'package:perseu/src/components/session_data/session_data.dart';
import 'package:perseu/src/viewModels/training_list_view_model.dart';

class TrainingSessionList extends StatefulWidget {
  const TrainingSessionList({Key? key}) : super(key: key);

  @override
  TrainingSessionListState createState() => TrainingSessionListState();
}

class TrainingSessionListState extends State<TrainingSessionList> {
  final List<TrainingCard> _data = generateItems(3);
  final List<ExerciseItem> items = generateExercises(2);

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

List<ExerciseItem> generateExercises(int numberOfItems) {
  return List<ExerciseItem>.generate(
    3,
    (i) => Exercise('Exercício $i', 'Descrição do exercício'),
  );
}
