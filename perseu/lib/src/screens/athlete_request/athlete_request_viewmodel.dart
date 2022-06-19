import 'package:perseu/src/services/foundation.dart';
import 'package:perseu/src/services/http_client_perseu.dart';
import 'package:perseu/src/states/foundation.dart';

import '../../app/locator.dart';

class AthleteRequestViewModel extends AppViewModel {
  HttpClientPerseu httpClientPerseu = locator<HttpClientPerseu>();
  String? requestCode;

  Future<Result> createRequest() async{
    return tryExec(() async {
       Result result = await httpClientPerseu.createRequest(requestCode!, session.user!.athlete!.id);
       if(result.success){
         return Result.success(message: 'Sucesso ao criar pedido de ingresso, atualmente seu pedido está ${result.data}');
       } else {
         return result;
       }
    });

  }
}