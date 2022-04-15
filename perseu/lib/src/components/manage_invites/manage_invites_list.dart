import 'package:flutter/material.dart';

class ManageInvitesList extends StatefulWidget {
  const ManageInvitesList({Key? key}) : super(key: key);

  @override
  ManageInvitesListState createState() => ManageInvitesListState();
}

class ManageInvitesListState extends State<ManageInvitesList> {
  final List<ListTile> lt = generateList(2);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lt,
    );
  }
}

List<ListTile> generateList(int numberOfItems) {
  return List.generate(numberOfItems, (index) {
    return ListTile(
      title: const Text('Atleta'),
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
