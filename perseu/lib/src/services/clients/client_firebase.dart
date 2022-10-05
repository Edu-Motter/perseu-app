import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/session.dart';

class ClientFirebase {
  final FirebaseFirestore clientFirestore = locator.get<FirebaseFirestore>();

  void addUser(Map<String, dynamic> user) async {
    final doc = await clientFirestore.collection('users').add(user);
    debugPrint('success added user with id: ${doc.id}');
  }

  Future<Result> saveMessage(String message, UserSession session) async {
    String userName = 'Desconhecido';
    if(session.isAthlete) userName = session.athlete!.name;
    if(session.isCoach) userName = session.coach!.name;

    try {
      await clientFirestore
          .collection('teams')
          .doc(session.team!.name)
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
}
