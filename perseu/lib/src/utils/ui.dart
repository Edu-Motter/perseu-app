import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:perseu/src/app/locator.dart';
import 'package:perseu/src/components/widgets/center_loading.dart';
import 'package:perseu/src/states/style.dart';
import 'package:perseu/src/utils/flash_notification.dart' as flash;

import '../app/routes.dart';
import '../services/foundation.dart';

typedef FutureVoidCallback = Future<void> Function();

class UIHelper {
  // ignore: unused_element
  UIHelper._();

  static const _errorDuration = Duration(milliseconds: 3200);

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
                duration: _errorDuration)
            .show(context);
      }
    }
  }

  static void showSuccess(BuildContext context, Result result,
      {bool pop = false}) {
    assert(result.success);
    if (pop) Navigator.pop(context);
    Flushbar(
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            message: result.message ?? 'Comando executado com sucesso',
            duration: _errorDuration)
        .show(context);
  }

  static void showSuccessThenExecute(
      BuildContext context, Result result, Function execute) {
    assert(result.success);
    Flushbar(
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            message: result.message ?? 'Comando executado com sucesso',
            duration: _errorDuration)
        .show(context)
        .then((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      execute();
    });
  }

  static void showSuccessWithRoute(
      BuildContext context, Result result, Function route) async {
    assert(result.success);
    Flushbar(
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
            message: result.message ?? 'Comando executado com sucesso',
            duration: _errorDuration)
        .show(context)
        .then((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      route();
    });
  }

  static void showInfo(BuildContext context, String message,
      {IconData icon = Icons.check_circle_outline,
      Duration duration = const Duration(seconds: 1)}) {
    Flushbar(
            icon: Icon(icon, color: Colors.white),
            message: message,
            duration: duration)
        .show(context);
  }

  static Future<bool?> showBoolDialog({
    required BuildContext context,
    required VoidCallback onNoPressed,
    required FutureVoidCallback onYesPressed,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BoolDialog(
        title: title,
        message: message,
        onNoPressed: onNoPressed,
        onYesPressed: onYesPressed,
      ),
    );
  }

  static Future<bool?> showBool({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    final style = locator<Style>();
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            style: style.buttonAlertSecondary,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          ElevatedButton(
            style: style.buttonAlertPrimary,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }

  static Future<void> showSimpleDialog(BuildContext context,
      {required String title, required String message}) {
    return _showDialog(context, _SimpleDialog(title: title, message: message));
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
      {IconData icon = Icons.check,
      Duration duration = const Duration(seconds: 1)}) {
    flash.showFlashNotification(
        context, flash.FlashNotification.simple(icon, message),
        duration: duration);
  }

  static Size textPixelSize(
    String text, {
    TextStyle style = const TextStyle(color: Colors.black),
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance!.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }
}

class BoolDialog extends StatefulWidget {
  const BoolDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onNoPressed,
    required this.onYesPressed,
  }) : super(key: key);

  final String title;
  final String message;
  final VoidCallback onNoPressed;
  final FutureVoidCallback onYesPressed;

  @override
  State<BoolDialog> createState() => _BoolDialogState();
}

class _BoolDialogState extends State<BoolDialog> {
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    final style = locator<Style>();

    if (busy) {
      return const AlertDialog(
        content: SizedBox(
          height: 60,
          width: 60,
          child: CircularLoading(),
        ),
      );
    }

    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      actions: [
        ElevatedButton(
          style: style.buttonAlertSecondary,
          onPressed: widget.onNoPressed,
          child: const Text('Não'),
        ),
        ElevatedButton(
          style: style.buttonAlertPrimary,
          onPressed: () async {
            setState(() => busy = true);
            await widget.onYesPressed();
            setState(() => busy = false);
          },
          child: const Text('Sim'),
        ),
      ],
    );
  }
}

class _SessionExpiredDialog extends _SimpleDialog {
  const _SessionExpiredDialog()
      : super(
            title: 'Sessão expirada',
            message: 'Sua sessão expirou, faça o login novamente');

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      TextButton(
        onPressed: () {
          //locator<Session>().reset();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.login, (_) => false);
        },
        child: const Text('OK'),
      ),
    ];
  }
}

class _GenericErrorDialog extends _SimpleDialog {
  const _GenericErrorDialog({String message = 'Erro genérico'})
      : super(title: 'Erro', message: message);
}

class _NotImplementedDialog extends _SimpleDialog {
  const _NotImplementedDialog()
      : super(
            title: 'Não implementado',
            message: 'Funcionalidade não implementada');
}

class _SimpleDialog extends StatelessWidget {
  final String title;
  final String message;

  const _SimpleDialog({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
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
