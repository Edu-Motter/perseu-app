import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/screens/team_chat/team_chat_viewmodel.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

class TeamChatScreen extends StatefulWidget {
  const TeamChatScreen({Key? key}) : super(key: key);

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<TeamChatViewModel>(),
      child: Consumer<TeamChatViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${model.teamName} chat'),
              actions: [
                if (model.user.isCoach) IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Center(
                                child: Text('Configuração do Chat'),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Divider(),
                                  Row(children: [
                                    const Text('Habilitar chat para atletas?'),
                                    Switch(value: true, onChanged: (value){})
                                  ],),
                                ],
                              ),
                            );
                          });
                    }),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('teams')
                        .doc(model.teamName)
                        .collection('chat')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.length > 1) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            itemBuilder: (context, index) {
                              final chat = snapshot.data!.docs[index];
                              return MessageWidget(
                                userName: chat['userName'],
                                message: chat['message'],
                                isOwner: chat['userId'] == model.user.email,
                              );
                            },
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text(
                                  'Inicie a conversa!',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 36),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Icon(
                                Icons.chat,
                                size: 56,
                                color: Colors.teal,
                              ),
                            ],
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const Center(
                          child: Text('Erro interno'),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 10.0,
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 1,
                            cursorColor: Colors.teal,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2.5, color: Colors.teal),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2.5, color: Colors.teal),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            if (model.isNotBusy){
                              model.sendMessage(_controller.text);
                              _controller.clear();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: model.isNotBusy ? Colors.teal : Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.message,
    required this.userName,
    required this.isOwner,
  }) : super(key: key);

  final String message;
  final bool isOwner;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        isOwner ? Colors.teal : Colors.black87.withOpacity(.75);
    final Color? randomColor = isOwner ? Colors.white : Colors.teal[200];
    final nameSize = UIHelper.textPixelSize(userName);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
              width: nameSize.width + 16,
              height: nameSize.height + 8,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  userName,
                  style: TextStyle(color: randomColor),
                  overflow: TextOverflow.ellipsis,
                ),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: const Radius.circular(8),
                      bottomLeft: const Radius.circular(8),
                      topRight: isOwner
                          ? const Radius.circular(0)
                          : const Radius.circular(8),
                      topLeft: isOwner
                          ? const Radius.circular(8)
                          : const Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: isOwner
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: nameSize.width + 16),
                        Text(
                          message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
