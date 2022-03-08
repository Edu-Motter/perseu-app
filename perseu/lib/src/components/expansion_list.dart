import 'package:flutter/material.dart';

class ExpansionList extends StatefulWidget {
  const ExpansionList({Key? key}) : super(key: key);

  @override
  _ExpansionListState createState() => _ExpansionListState();
}

class _ExpansionListState extends State<ExpansionList> {
  final List<Item> _data = generateItems(10);

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
            subtitle: const Text('Apagar sessão'),
            trailing: const Icon(Icons.delete),
            onTap: () {
              setState(() {
                _data.removeWhere((currentItem) => item == currentItem);
              });
            },
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return Item(
      headerValue: 'Sessão #$index',
      expandedValue: 'Exercicios $index',
      isExpanded: false,
    );
  });
}
