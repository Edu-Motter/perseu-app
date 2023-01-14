import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/athlete_dto.dart';
import 'package:perseu/src/models/dtos/group_dto.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/group_chat/group_chat_screen.dart';
import 'package:perseu/src/screens/group_details/group_details_viewmodel.dart';
import 'package:perseu/src/screens/manage_athletes/manage_athletes_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:provider/provider.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  final int groupId;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupDetailsViewModel>(
      create: (_) => locator<GroupDetailsViewModel>(),
      child: Consumer<GroupDetailsViewModel>(
        builder: (__, model, _) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: Text(groupName),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Palette.accent,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GroupChatScreen(groupId: groupId, groupName: groupName),
                ),
              ),
              child: const Icon(Icons.chat),
            ),
            body: FutureBuilder(
              future: model.getGroupDetails(groupId),
              builder: (context, AsyncSnapshot<Result<GroupDTO>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData && snapshot.data!.success) {
                      final group = snapshot.data!.data!;
                      return Column(
                        children: [
                          ListTitle(
                              text: 'Quantidade de atletas no grupo: '
                                  '${group.athletes.length}'),
                          Expanded(
                            child: group.athletes.isNotEmpty
                                ? GroupAthletesList(athletes: group.athletes)
                                : const PerseuMessage(
                                    message: 'Nenhum atleta nesse grupo',
                                    icon: Icons.mood_bad,
                                  ),
                          ),
                        ],
                      );
                    } else {
                      return const PerseuMessage(
                        message: 'Falha ao carregar informações desse grupo',
                        icon: Icons.error,
                      );
                    }
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class GroupAthletesList extends StatelessWidget {
  const GroupAthletesList({Key? key, required this.athletes}) : super(key: key);

  final List<AthleteDTO> athletes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: athletes.length,
        itemBuilder: (context, index) {
          final athlete = athletes[index];
          return Card(
            margin: const EdgeInsets.only(top: 8),
            child: ListTile(
                title: Text(
                  athlete.name,
                  style: const TextStyle(
                      color: Palette.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.clear,
                  color: Palette.secondary,
                  size: 28,
                ),
                onTap: () {}),
          );
        },
      ),
    );
  }
}
