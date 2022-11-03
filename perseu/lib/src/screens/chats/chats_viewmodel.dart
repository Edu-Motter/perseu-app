import 'package:perseu/src/states/foundation.dart';

class ChatsViewModel extends AppViewModel {
  int get userId => session.userSession!.user.id;
}
