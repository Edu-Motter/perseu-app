import 'package:flutter/material.dart';
import 'package:perseu/src/app/routes.dart';

class CoachHomeScreen extends StatelessWidget {
  const CoachHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color themeColor = Colors.teal;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          automaticallyImplyLeading: false,
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Equipe Teste', style: TextStyle(fontSize: 32)),
                const Text('33 atletas', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.newTraining),
                    child: const Text('Novo treino',
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
                    child: const Text('Gerenciar grupos',
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.manageInvites),
                    child: const Text('Gerenciar solicitações',
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
                    child: const Text('Gerenciar relatórios',
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
