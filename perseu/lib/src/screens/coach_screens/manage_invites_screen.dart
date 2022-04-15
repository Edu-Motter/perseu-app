import 'package:flutter/material.dart';
import 'package:perseu/src/components/manage_invites/manage_invites_list.dart';

class ManageInvitesScreen extends StatelessWidget {
  const ManageInvitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Solicitações'),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Equipe Teste'),
                Text('Código de acesso: 12345')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [ManageInvitesList()],
            ),
          ),
        ]));
  }
}
