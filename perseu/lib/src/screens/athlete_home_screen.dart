import 'package:flutter/material.dart';

class AthleteHomeScreen extends StatelessWidget {
  const AthleteHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Olá, usuário!'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.teal,
                            width: 1.0,
                            style: BorderStyle.solid)),
                        foregroundColor: MaterialStateProperty.all(themeColor),
                        overlayColor: MaterialStateProperty.all(themeColor)),
                    onPressed: null,
                    child: const Text('Visualizar treino de hoje',
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 32),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.teal,
                            width: 1.0,
                            style: BorderStyle.solid)),
                        foregroundColor: MaterialStateProperty.all(themeColor),
                        overlayColor: MaterialStateProperty.all(themeColor)),
                    onPressed: null,
                    child: const Text('Visualizar conversas',
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 8),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.teal,
                            width: 1.0,
                            style: BorderStyle.solid)),
                        foregroundColor: MaterialStateProperty.all(themeColor),
                        overlayColor: MaterialStateProperty.all(themeColor)),
                    onPressed: null,
                    child: const Text('Visualizar calendário',
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 8),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(const BorderSide(
                            color: Colors.teal,
                            width: 1.0,
                            style: BorderStyle.solid)),
                        foregroundColor: MaterialStateProperty.all(themeColor),
                        overlayColor: MaterialStateProperty.all(themeColor)),
                    onPressed: null,
                    child: const Text('Gerenciar perfil',
                        style: TextStyle(fontSize: 16))),
              ],
            ),
          ),
        ]));
  }
}
