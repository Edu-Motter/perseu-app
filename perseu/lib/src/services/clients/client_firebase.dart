import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/session.dart';

class ClientFirebase {
  final FirebaseFirestore clientFirestore = locator.get<FirebaseFirestore>();

  Future<Result> saveMessage(String message, UserSession session) async {
    String userName = 'Desconhecido';
    if (session.isAthlete) userName = session.athlete!.name;
    if (session.isCoach) userName = session.coach!.name;

    try {
      await clientFirestore
          .collection('teams')
          .doc(session.team!.id.toString())
          .collection('chat')
          .add({
        'userName': userName,
        'message': message,
        'date': DateTime.now(),
        'userId': session.user.email,
      });
      return const Result.success();
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }

  Future<Result> saveMessageUserToUser({
    required String message,
    required String userName,
    required int friendId,
    required UserSession userSession,
  }) async {
    final messageData = {
      'userName': userName,
      'message': message,
      'date': DateTime.now(),
      'userEmail': userSession.user.email,
      'userId': userSession.user.id,
    };

    try {
      //Saves on user's collection
      await clientFirestore
          .collection('users')
          .doc(userSession.user.id.toString())
          .collection('chats')
          .doc(friendId.toString())
          .collection('messages')
          .add(messageData)
          .then((_) => clientFirestore
              .collection('users')
              .doc(userSession.user.id.toString())
              .collection('chats')
              .doc(friendId.toString())
              .set({'lastMessage': message}));
      //Saves on friend's collection
      await clientFirestore
          .collection('users')
          .doc(friendId.toString())
          .collection('chats')
          .doc(userSession.user.id.toString())
          .collection('messages')
          .add(messageData)
          .then((_) => clientFirestore
              .collection('users')
              .doc(friendId.toString())
              .collection('chats')
              .doc(userSession.user.id.toString())
              .set({'lastMessage': message}));
      return const Result.success();
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }
}
