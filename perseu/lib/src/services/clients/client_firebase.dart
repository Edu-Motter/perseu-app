import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/states/session.dart';

class ClientFirebase extends ApiHelper {
  final FirebaseFirestore firestore = locator.get<FirebaseFirestore>();
  final Dio dio = locator.get<Dio>();

  Future<Result> saveMessage(String message, UserSession session) async {
    String userName = 'Desconhecido';
    if (session.isAthlete) userName = session.athlete!.name;
    if (session.isCoach) userName = session.coach!.name;

    final teamId = session.team!.id.toString();

    try {
      await firestore.collection('teams').doc(teamId).collection('chat').add({
        'userName': userName,
        'message': message,
        'date': DateTime.now(),
        'userId': session.user.email,
      }).then((_) => firestore.collection('teams').doc(teamId).set({
            'lastMessage': '$userName: $message',
            'userId': session.user.id.toString(),
          }));
      return const Result.success();
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }

  Stream<QuerySnapshot> getGroupMessages({
    required int groupId,
    required int teamId,
  }) {
    return firestore
        .collection('teams')
        .doc(teamId.toString())
        .collection('groups')
        .doc(groupId.toString())
        .collection('chat')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersMessages({
    required int userId,
    required int friendId,
    required int teamId,
  }) {
    return firestore
        .collection('teams')
        .doc(teamId.toString())
        .collection('users')
        .doc(userId.toString())
        .collection('chats')
        .doc(friendId.toString())
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getTeamMessages({required int teamId}) {
    return firestore
        .collection('teams')
        .doc(teamId.toString())
        .collection('chat')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getTeamLastMessage({required int teamId}) {
    return firestore.collection('teams').doc(teamId.toString()).snapshots();
  }

  Stream<QuerySnapshot> getUsersLastMessages({
    required int userId,
    required int teamId,
  }) {
    return firestore
        .collection('teams')
        .doc(teamId.toString())
        .collection('users')
        .doc(userId.toString())
        .collection('chats')
        .snapshots();
  }

  Stream<DocumentSnapshot> getGroupsLastMessages({
    required int groupId,
    required int teamId,
  }) {
    return firestore
        .collection('teams')
        .doc(teamId.toString())
        .collection('groups')
        .doc(groupId.toString())
        .snapshots();
  }

  Future<Result> saveMessageGroup({
    required String message,
    required int groupId,
    required UserSession session,
  }) async {
    String teamId = session.team!.id.toString();
    String userName = 'Desconhecido';
    if (session.isAthlete) userName = session.athlete!.name;
    if (session.isCoach) userName = session.coach!.name;

    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('groups')
          .doc(groupId.toString())
          .collection('chat')
          .add({
        'userName': userName,
        'message': message,
        'date': DateTime.now(),
        'userId': session.user.id,
      }).then((_) => firestore
                  .collection('teams')
                  .doc(teamId)
                  .collection('groups')
                  .doc(groupId.toString())
                  .set({
                'lastMessage': '$userName: $message',
                'userId': session.user.id.toString(),
              }));
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

    String teamId = userSession.team!.id.toString();

    try {
      //Saves on user's collection
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('users')
          .doc(userSession.user.id.toString())
          .collection('chats')
          .doc(friendId.toString())
          .collection('messages')
          .add(messageData)
          .then((_) => firestore
                  .collection('teams')
                  .doc(teamId)
                  .collection('users')
                  .doc(userSession.user.id.toString())
                  .collection('chats')
                  .doc(friendId.toString())
                  .set({
                'lastMessage': '$userName: $message',
                'userId': userSession.user.id.toString(),
              }));
      //Saves on friend's collection
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('users')
          .doc(friendId.toString())
          .collection('chats')
          .doc(userSession.user.id.toString())
          .collection('messages')
          .add(messageData)
          .then((_) => firestore
                  .collection('teams')
                  .doc(teamId)
                  .collection('users')
                  .doc(friendId.toString())
                  .collection('chats')
                  .doc(userSession.user.id.toString())
                  .set({
                'lastMessage': '$userName: $message',
                'userId': userSession.user.id.toString(),
              }));
      return const Result.success();
    } catch (e) {
      return Result.error(message: e.toString());
    }
  }

  Future<Result> saveDeviceToken(
    String deviceToken,
    int userId,
    String authToken,
  ) async {
    return process(
      dio.post(
        '/user/$userId/notification/token',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
        data: {'token': deviceToken},
      ),
      onSuccess: (response) => const Result.success(),
      onError: (response) =>
          const Result.error(message: 'Falha ao salvar device token'),
    );
  }

  Future<Result<String>> getDeviceToken(
    int userId,
    String authToken,
  ) async {
    return process(
      dio.get(
        '/user/$userId/notification/token',
        options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ),
      ),
      onSuccess: (response) => Result.success(data: response.data['token']),
      onError: (response) =>
          const Result.error(message: 'Falha ao resgatar device token'),
    );
  }
}
