import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/screens/coach_manage_requests/coach_manage_requests_screen.dart';
import 'package:perseu/src/screens/user_chat/user_chat_viewmodel.dart';
import 'package:perseu/src/utils/date_formatters.dart';
import 'package:perseu/src/utils/palette.dart';
import 'package:perseu/src/utils/ui.dart';
import 'package:provider/provider.dart';

class UsersChatScreen extends StatefulWidget {
  const UsersChatScreen({
    Key? key,
    required this.friendId,
    required this.friendName,
  }) : super(key: key);

  final int friendId;
  final String friendName;

  @override
  State<UsersChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<UsersChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<UserChatViewModel>(),
      child: Consumer<UserChatViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Palette.background,
            appBar: AppBar(
              title: Text(widget.friendName),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(model.userId.toString())
                        .collection('chats')
                        .doc(widget.friendId.toString())
                        .collection('messages')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            itemBuilder: (context, index) {
                              final chat = snapshot.data!.docs[index];
                              // final  = chat['date'];
                              return MessageWidget(
                                userName: chat['userName'],
                                message: chat['message'],
                                date: (chat['date'] as Timestamp).toDate(),
                                isOwner: chat['userId'] == model.userId,
                              );
                            },
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/chat.png', height: 112, width: 112,),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text(
                                    'Inicie a conversa',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Palette.primary, fontSize: 24),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularLoading();
                      } else {
                        return PerseuMessage.defaultError();
                      }
                    },
                  ),
                ),
                Container(
                  color: Palette.background,
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
                            cursorColor: Palette.primary,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Mensagem',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.5, color: Palette.primary),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.5, color: Palette.primary),
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
                            if (model.isNotBusy) {
                              if (_controller.text.isEmpty) return;
                              model.sendMessage(
                                  _controller.text, widget.friendId);
                              _controller.clear();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  model.isNotBusy ? Palette.accent : Colors.grey,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.send,
                              color: Colors.white
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
    required this.date,
    required this.userName,
    required this.isOwner,
  }) : super(key: key);

  final String message;
  final DateTime date;
  final bool isOwner;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = isOwner ? Palette.primary : Palette.secondary;
    final Color? randomColor = isOwner ? Colors.white : Colors.white;

    final nameSize = UIHelper.textPixelSize(userName);
    BoxDecoration messageBoxDecoration =
        buildMessageBoxDecoration(primaryColor, nameSize.width);

    final messageSize = UIHelper.textPixelSize(message,
        style: const TextStyle(color: Colors.white, fontSize: 16));

    const padding = 6.0;
    final bool closeToNameWidth = (messageSize.width > nameSize.width &&
        (messageSize.width - padding) < nameSize.width);

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
                  decoration: messageBoxDecoration,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: isOwner
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: nameSize.width),
                              if (closeToNameWidth)
                                SizedBox(width: nameSize.width + padding),
                              Text(
                                message,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: isOwner
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: nameSize.width),
                              SizedBox(width: messageSize.width),
                              if (closeToNameWidth)
                                SizedBox(width: nameSize.width + padding),
                              Text(
                                DateFormatters.toTime(date),
                                style: TextStyle(
                                    color: Palette.background.withOpacity(.5),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration buildMessageBoxDecoration(Color color, double nameWidth) {
    final messageSize = UIHelper.textPixelSize(message,
        style: const TextStyle(color: Colors.white, fontSize: 16));

    if (nameWidth >= messageSize.width) {
      return BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
      );
    }

    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomRight: const Radius.circular(8),
        bottomLeft: const Radius.circular(8),
        topRight: isOwner ? const Radius.circular(0) : const Radius.circular(8),
        topLeft: isOwner ? const Radius.circular(8) : const Radius.circular(0),
      ),
    );
  }
}
