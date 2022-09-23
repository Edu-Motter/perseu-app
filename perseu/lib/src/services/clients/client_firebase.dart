import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/models/requests/team_request.dart';
import 'package:perseu/src/models/requests/user_request.dart';
import 'package:perseu/src/services/foundation.dart';

class ClientFirebase {
  final FirebaseFirestore clientFirestore = locator.get<FirebaseFirestore>();

  void addUser(Map<String, dynamic> user) async {
    final doc = await clientFirestore.collection('users').add(user);
    debugPrint('success added user with id: ${doc.id}');
  }

  Future<Result> saveMessage(String message, UserRequest user) async {
    TeamRequest team;
    if (user.isCoach) {
      team = user.coach!.team!;
    } else {
      team = user.athlete!.team!;
    }

    try {
      await clientFirestore
          .collection('teams')
          .doc(team.name)
          .collection('chat')
          .add({
        'userName': user.name,
        'message': message,
        'date': DateTime.now(),
        'userId': user.email,
      });
      return const Result.success();
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }
}
