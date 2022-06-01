import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/utils/flash_notification.dart' as flash;

import '../app/locator.dart';
import '../app/routes.dart';
import '../services/foundation.dart';

class UIHelper {
  // ignore: unused_element
  UIHelper._();

  static const _errorDuration = Duration(seconds: 4);

  static void showError(BuildContext context, Result result,
      {bool dialog = false}) {
    assert(result.error);
    if (result.errorType == ErrorType.unauthorized) {
      _showDialog(context, const _SessionExpiredDialog());
    } else {
      if (dialog && result.message != null) {
        _showDialog(context, _GenericErrorDialog(message: result.message!));
      } else {
        Flushbar(
            icon: const Icon(Icons.error_outline, color: Colors.red),
            message: result.message,
            duration: _errorDuration
        ).show(context);
      }
    }
  }

  static void showSuccess(BuildContext context, Result result) {
    assert(result.success);
    Flushbar(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        message: result.message ?? 'Comando executado com sucesso',
        duration: _errorDuration
    ).show(context);
  }

  static void showSuccessWithRoute(BuildContext context, Result result, Function route) async {
    assert(result.success);
    Flushbar(
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        message: result.message ?? 'Comando executado com sucesso',
        duration: _errorDuration
    ).show(context).then((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      route();
    } );
  }


  static void showInfo(BuildContext context, String message,
      {IconData icon = Icons.check_circle_outline,
        Duration duration = const Duration(seconds: 1)}) {
    Flushbar(
        icon: Icon(icon, color: Colors.white),
        message: message,
        duration: duration
    ).show(context);
  }

  static Future<void> showSimpleDialog(BuildContext context, {required String title, required String message}) {
    return _showDialog(context, _SimpleDialog(title: title,  message: message));
  }

  static Future<void> showNotImplementedDialog(BuildContext context) {
    return _showDialog(context, const _NotImplementedDialog());
  }

  static Future<void> _showDialog(BuildContext context, Widget child) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => child,
    );
  }

  static void showFlashNotification(BuildContext context, String message,
      {IconData icon = Icons.check, Duration duration = const Duration(seconds: 1)}) {
    flash.showFlashNotification(context,
        flash.FlashNotification.simple(icon, message), duration: duration);
  }
}

class _SessionExpiredDialog extends _SimpleDialog {
  const _SessionExpiredDialog(): super(title: 'Sessão expirada', message: 'Sua sessão expirou, faça o login novamente');

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () {
          //locator<Session>().reset();
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.login, (_) => false);
        },
        child: const Text('OK'),
      ),
    ];
  }
}

class _GenericErrorDialog extends _SimpleDialog {
  const _GenericErrorDialog({String message = 'Erro genérico'}): super(title: 'Erro', message: message);
}

class _NotImplementedDialog extends _SimpleDialog {
  const _NotImplementedDialog(): super(title: 'Não implementado', message: 'Funcionalidade não implementada');
}

class _SimpleDialog extends StatelessWidget {
  final String title;
  final String message;

  const _SimpleDialog({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title == null ? null : Text(title),
      content: Text(message),
      actions: buildActions(context),
    );
  }

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
      ),
    ];
  }
}
