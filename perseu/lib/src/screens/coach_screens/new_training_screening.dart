// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:perseu/src/components/training_list.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class NewTrainingScreen extends StatelessWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo treino'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          // child: const Icon(Icons.add),
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.add),
              onTap: () => print('FIRST CHILD'),
              label: 'Adicionar sessão',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            SpeedDialChild(
              child: const Icon(Icons.forward),
              onTap: () => print('SECOND CHILD'),
              label: 'Atribuir treino',
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
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
