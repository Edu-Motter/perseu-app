import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/models/dtos/group_name_dto.dart';
import 'package:perseu/src/screens/group_chat/group_chat_screen.dart';
import 'package:perseu/src/screens/user_chat/user_chat_screen.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/utils/palette.dart';
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
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: const Text('Conversas'),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Palette.accent,
              child: const Icon(Icons.add, size: 28),
              onPressed: () => Navigator.pushNamed(context, Routes.usersToChat),
            ),
            body: SystemOnline(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Visibility(
                          visible: model.isTeamChatVisible,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  getCircleLetters(model.teamName),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Palette.secondary,
                              ),
                              title: Text(model.teamName),
                              subtitle: StreamBuilder(
                                stream: model.getTeamLastMessage(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    String lastMessage =
                                        handleLastMessage(snapshot.data, model);
                                    return Text(
                                      lastMessage,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }
                                  return const CircularLoading();
                                },
                              ),
                              onTap: () =>
                                  Navigator.pushNamed(context, Routes.teamChat),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  'Equipe',
                                  style: TextStyle(
                                    color: Palette.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => model.changeTeamChatVisibility(),
                                child: _getIcon(model.isTeamChatVisible),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  SliverToBoxAdapter(
                    child: _buildGroupsTiles(model),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),
                  StreamBuilder(
                    stream: model.getUsersLastMessages(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final String friendIdString =
                                    snapshot.data!.docs[index].id;
                                final int? friendId =
                                    int.tryParse(friendIdString);
                                final String lastMessage = handleLastMessage(
                                    snapshot.data!.docs[index], model);
                                return FutureBuilder(
                                  future: model.getFriendName(friendId!),
                                  builder:
                                      (context, AsyncSnapshot<String> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                      case ConnectionState.active:
                                        return const CircularLoading();
                                      case ConnectionState.done:
                                        if (snapshot.hasData) {
                                          String friendName =
                                              snapshot.data ?? 'Não encontrado';
                                          return ListTile(
                                              leading: CircleAvatar(
                                                child: Text(
                                                  getCircleLetters(friendName),
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor:
                                                    Palette.secondary,
                                              ),
                                              title: Text(friendName),
                                              subtitle: Text(
                                                lastMessage,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UsersChatScreen(
                                                      friendId: friendId,
                                                      friendName: friendName,
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return const CenterError(
                                              message: 'Não encontrado');
                                        }
                                    }
                                  },
                                );
                              },
                              childCount: snapshot.data!.docs.length,
                            ),
                          );
                        } else {
                          return SliverToBoxAdapter(
                            child: Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('Nenhum chat individual encontrado'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SliverToBoxAdapter(child: CircularLoading());
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Icon _getIcon(bool visible) {
    if (visible) {
      return const Icon(Icons.keyboard_arrow_up_rounded,
          color: Palette.secondary);
    }

    return const Icon(Icons.keyboard_arrow_down_rounded,
        color: Palette.secondary);
  }

  static String getCircleLetters(String name) {
    List<String> names = name.split(' ');

    String firstCharacterFirstName = getFirstCharacter(names.first);
    String firstCharacterLastName = getFirstCharacter(names.last);

    if (names.length == 1) return firstCharacterFirstName;

    return '$firstCharacterFirstName$firstCharacterLastName';
  }

  static String getFirstCharacter(String string) {
    return string.substring(0, 1).toUpperCase();
  }

  Widget _buildGroupsTiles(ChatsViewModel model) {
    return FutureBuilder(
      future: model.getUserGroups(),
      builder: (context, AsyncSnapshot<Result<List<GroupNameDTO>>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return const CircularLoading();
          case ConnectionState.done:
            if (snapshot.data!.error) {
              return ListTile(
                  leading: const CircleAvatar(
                    child: Text(
                      'E',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Palette.secondary,
                  ),
                  title: const Text('Grupos'),
                  subtitle: const Text('Não foi possível carregar os grupos'),
                  onTap: () {});
            }
            final List<GroupNameDTO> groups = snapshot.data!.data!;
            return Stack(
              children: [
                Visibility(
                  visible: model.isGroupsChatVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      children: [
                        for (GroupNameDTO group in groups)
                          ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                getCircleLetters(group.name),
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Palette.secondary,
                            ),
                            title: Text(group.name),
                            subtitle: StreamBuilder(
                              stream: model.getGroupsLastMessages(group.id),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  String lastMessage =
                                      handleLastMessage(snapshot.data, model);
                                  return Text(
                                    lastMessage,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                                return const CircularLoading();
                              },
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => GroupChatScreen(
                                    groupId: group.id, groupName: group.name)),
                              ),
                            ),
                          ),
                        if (groups.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text('Nenhum chat em grupo foi criado'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Grupos',
                          style: TextStyle(
                            color: Palette.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => model.changeGroupsChatVisibility(),
                        child: _getIcon(model.isGroupsChatVisible),
                      ),
                    ],
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  String handleLastMessage(DocumentSnapshot? data, ChatsViewModel model) {
    if (data == null || !(data.exists)) return 'Inicie a conversa';

    String lastMessage = data.get('lastMessage');

    int? messageUserId;
    try {
      data.get('userId');
      messageUserId = int.tryParse(data.get('userId'));
    } catch (e) {
      return lastMessage;
    }

    if (messageUserId == model.userId) {
      var index = lastMessage.indexOf(':');
      lastMessage = lastMessage.replaceRange(0, index, 'Você');
    }

    return lastMessage;
  }
}
