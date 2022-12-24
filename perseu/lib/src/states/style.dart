import 'package:flutter/material.dart';
import 'package:perseu/src/utils/palette.dart';

class Style extends ChangeNotifier {
  ButtonStyle get buttonAlertSecondary => ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(Palette.accent),
        side: MaterialStateProperty.all(
          const BorderSide(color: Palette.accent, width: 2),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(104, 32),
        ),
      );

  ButtonStyle get buttonAlertPrimary {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey;
        } else {
          return Palette.accent;
        }
      }),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      minimumSize: MaterialStateProperty.all(
        const Size(104, 32),
      ),
    );
  }
}
