import 'package:flutter/material.dart';
import 'package:perseu/src/components/expansion_list.dart';

class NewTrainingScreen extends StatelessWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo treino'),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [ExpansionList()],
            ),
          ),
        ]));
  }
}
