import 'package:perseu/src/states/foundation.dart';

import '../../services/foundation.dart';

class ProfileViewModel extends AppViewModel {
  String? name;
  String? email;
  String? birthday;
  String? cpf;
  String? cref;
  String? weight;
  String? height;

  bool get isAthlete => session.user!.athlete != null;
  bool get isCoach => session.user!.coach != null;

  Future<Result> save() async {
    await Future.delayed(const Duration(seconds: 10));
    return const Result.success();
  }
}