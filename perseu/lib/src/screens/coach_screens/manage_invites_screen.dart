import 'package:flutter/material.dart';
import 'package:perseu/src/components/manage_invites/manage_invites_list.dart';
import 'package:perseu/src/models/solicitations_model.dart';

class ManageInvitesScreen extends StatefulWidget {
  const ManageInvitesScreen({Key? key}) : super(key: key);

  @override
  ManageInvitesScreenState createState() => ManageInvitesScreenState();
}

class ManageInvitesScreenState extends State<ManageInvitesScreen> {
  final List<SolicitationsModel> solicitations = [
    SolicitationsModel(id: 1, name: 'Carlitos'),
    SolicitationsModel(id: 2, name: 'Edu'),
    SolicitationsModel(id: 3, name: 'João')
  ];

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
                Text('Código de acesso: 12345'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ManageInvitesList(solicitations: solicitations)],
            ),
          ),
        ]));
  }
}
