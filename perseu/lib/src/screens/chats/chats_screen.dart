import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:provider/provider.dart';

import 'chats_viewmodel.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<ChatsViewModel>(),
      child: Consumer<ChatsViewModel>(
        builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Conversas'),
            ),
            floatingActionButton: SizedBox(
              width: 140,
              child: ElevatedButton(
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Nova conversa',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(Icons.message),
                  ],
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.usersToChat),
              ),
            ),
            body: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    child: Text(
                      'T',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  title: const Text('Equipe'),
                  subtitle: const Text(
                    'Ultima mensangem da equipe',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.pushNamed(context, Routes.teamChat),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
