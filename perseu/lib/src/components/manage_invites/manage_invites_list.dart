import 'package:flutter/material.dart';
import 'package:perseu/src/models/solicitations_model.dart';

class ManageInvitesList extends StatefulWidget {
  const ManageInvitesList({Key? key, required this.solicitations})
      : super(key: key);
  final SolicitationsModel solicitations;

  @override
  ManageInvitesListState createState() => ManageInvitesListState();
}

class ManageInvitesListState extends State<ManageInvitesList> {
  late final SolicitationsModel solicitations = widget.solicitations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: generateList(2, solicitations),
    );
  }
}

List<ListTile> generateList(
    int numberOfItems, SolicitationsModel solicitations) {
  return List.generate(numberOfItems, (index) {
    return ListTile(
      title: Text(solicitations.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.clear)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
        ],
      ),
    );
  });
}
