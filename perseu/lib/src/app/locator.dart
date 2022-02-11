import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:perseu/src/services/http_client_perseu.dart';

final GetIt locator = GetIt.I;

void initializeLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options
      ..baseUrl = 'http://192.168.1.188:8080' //'http://0.0.0.0:8080/'
      ..connectTimeout = 5000
      ..receiveTimeout = 5000
      ..validateStatus = (int? status) {
        return status != null && status > 0;
      }
      ..headers = {
        HttpHeaders.userAgentHeader: 'dio',
        'common-header': 'xx',
      };

    return dio;
  });

  locator.registerLazySingleton<HttpClientPerseu>(() {
    // ignore: dead_code
    if (false /*mock*/) {
      //return HttpClientPerseuMock();
    } else {
      return HttpClientPerseu();
    }
  });
}
