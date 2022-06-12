import 'package:perseu/src/states/foundation.dart';

import '../../services/foundation.dart';

class AthletePendingRequestViewModel extends AppViewModel {

  Future<Result> checkRequestStatus(){
    return tryExec(() async {
      return const Result.success();
    });
  }

  Future<Result> cancelRequest(){
    return tryExec(() async {
      return const Result.success();
    });
  }
}