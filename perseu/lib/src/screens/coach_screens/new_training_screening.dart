import 'package:flutter/material.dart';

class NewTrainingScreen extends StatelessWidget {
  const NewTrainingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Novo treino'),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ExpansionPanelList(
                  animationDuration: const Duration(seconds: 2),
                  dividerColor: themeColor,
                  elevation: 1,
                  expandedHeaderPadding: const EdgeInsets.all((8)),
                  children: [
                    ExpansionPanel(
                        headerBuilder: (context, isOpen) {
                          return const Text("Hello");
                        },
                        body: const Text("Now Open!"),
                        isExpanded: false),
                  ],
                )
              ],
            ),
          ),
        ]));
  }
}
