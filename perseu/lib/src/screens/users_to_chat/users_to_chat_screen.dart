import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/dtos/user_chat_dto.dart';
import 'package:perseu/src/screens/user_chat/user_chat_screen.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:provider/provider.dart';

import 'users_to_chat_viewmodel.dart';

class UsersToChatScreen extends StatefulWidget {
  const UsersToChatScreen({Key? key}) : super(key: key);

  @override
  State<UsersToChatScreen> createState() => _UsersToChatScreenState();
}

class _UsersToChatScreenState extends State<UsersToChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<UsersToChatViewModel>(),
      child: Consumer<UsersToChatViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                model.searching
                    ? IconButton(
                        onPressed: () => model.searching = false,
                        icon: const Icon(Icons.close))
                    : IconButton(
                        onPressed: () => model.searching = true,
                        icon: const Icon(Icons.search))
              ],
              title: model.searching
                  ? TextField(
                      controller: _searchController,
                      onChanged: (value) => model.searchingValue = value,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )
                  : const Text('Nova conversa'),
            ),
            body: FutureBuilder(
              future: model.getUsers(_searchController.text),
              builder: (context, AsyncSnapshot<List<UserChatDTO>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const CircularLoading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return UsersList(users: model.users);
                    }
                    return const CenterError(
                      message: 'Erro ao buscar usuários',
                    );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class UsersList extends StatelessWidget {
  const UsersList({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<UserChatDTO> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final UserChatDTO user = users[index];
        return Card(
          child: ListTile(
            title: Text(user.name),
            trailing: const Icon(Icons.message, color: Colors.teal),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersChatScreen(
                    friendId: user.id,
                    friendName: user.name,
                  ),
                )),
          ),
        );
      },
    );
  }
}
