import 'package:flutter/foundation.dart';
import 'package:perseu/src/states/session.dart';


import '../app/locator.dart';
import '../services/foundation.dart';

class BaseViewModel extends ChangeNotifier {
  bool disposed = false;

  final Map<int, bool> _busyStates = <int, bool>{};

  bool busy(Object object) => _busyStates[object.hashCode] ?? false;

  bool get isBusy => busy(this);

  // ignore: avoid_positional_boolean_parameters
  void setBusy(bool value) {
    setBusyForObject(this, value);
  }

  // ignore: avoid_positional_boolean_parameters
  void setBusyForObject(Object object, bool value) {
    _busyStates[object.hashCode] = value;
    notifyListeners();
  }

  Future runBusyFuture(Future busyFuture, {required Object busyObject}) async {
    _setBusyForModelOrObject(true, busyObject: busyObject);
    final value = await busyFuture;
    _setBusyForModelOrObject(false, busyObject: busyObject);
    return value;
  }

  void _setBusyForModelOrObject(bool value, {required Object? busyObject}) {
    if (busyObject != null) {
      setBusyForObject(busyObject.hashCode, value);
    } else {
      setBusyForObject(this, value);
    }
  }

  /// Evita exceções caso o notifyListeners seja chamado após o dispose().
  /// Essa situação às vezes ocorre quando agendamos um Future.delayed, e
  /// ele executa após o model ter sido disposed.
  @mustCallSuper
  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  @mustCallSuper
  @override
  void notifyListeners() {
    if (disposed) {
      return;
    }
    super.notifyListeners();
  }
}

abstract class AppViewModel extends BaseViewModel {
  final Session session = locator<Session>();

  AppViewModel() {
    initState();
  }

  Future<Result<T>> tryExec<T>(Future<Result<T>> Function() block, {bool busy = true, Object? busyObject}) async {
    try {
      if (busy) {
        busyObject ??= this;
        setBusyForObject(busyObject, true);
      }
      return await block();
    } catch (error) {
      return Result.error(message: 'Erro: $error');
    } finally {
      if (busy) {
        setBusyForObject(busyObject!, false);
      }
    }
  }

  // bool onValidateSecurityCode(String input) {
  //   if (!session.authenticated || session.securityCode == null) {
  //     return false;
  //   }
  //   return session.securityCode == SecurityCode.fromPlain(input);
  // }

  void initState() {
  }

  bool authorized() {
    return true;
  }

}
