import 'package:flutter/material.dart';

class TrainingCard extends StatelessWidget {
  const TrainingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;
    return ExpansionPanelList(
      animationDuration: const Duration(seconds: 2),
      dividerColor: themeColor,
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all((8)),
      children: [
        ExpansionPanel(
            headerBuilder: (context, isOpen) {
              return const Text("Treino");
            },
            body: const Text("Now Open!"),
            isExpanded: false),
      ],
    );
  }
}
