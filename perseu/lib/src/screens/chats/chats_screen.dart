import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/app/routes.dart';
import 'package:perseu/src/components/widgets/center_error.dart';
import 'package:perseu/src/screens/user_chat/user_chat_screen.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
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
            body: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Text(
                      'T',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                  title: const Text('Equipe'),
                  subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('teams')
                        .doc(model.teamId.toString())
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final lastMessage = snapshot.data!.get('lastMessage');
                        return Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      }
                      return const CircularLoading();
                    },
                  ),
                  onTap: () => Navigator.pushNamed(context, Routes.teamChat),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(model.userId.toString())
                        .collection('chats')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final String friendIdString =
                                  snapshot.data!.docs[index].id;
                              final int? friendId =
                                  int.tryParse(friendIdString);
                              final String lastMessage =
                                  snapshot.data!.docs[index]['lastMessage'];
                              return FutureBuilder(
                                future: model.getFriendName(friendId!),
                                builder: (context, AsyncSnapshot<String> snapshot){
                                  switch(snapshot.connectionState){
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      return const CircularLoading();
                                    case ConnectionState.done:
                                      if (snapshot.hasData){
                                        String friendName = snapshot.data ?? 'Não encontrado';
                                        return ListTile(
                                            leading: CircleAvatar(
                                              child: Text(
                                                getCircleLetters(friendName),
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: Colors.teal,
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
                                                  builder: (context) => UsersChatScreen(
                                                    friendId: friendId,
                                                    friendName: friendIdString,
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return const CenterError(message: 'Não encontrado');
                                      }
                                  }
                                },
                              );
                            },
                          );
                        }
                      }
                      return const CircularLoading();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
}
