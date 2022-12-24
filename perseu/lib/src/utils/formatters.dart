import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formatters {
  // ignore: unused_element
  Formatters._();

  static MaskTextInputFormatter cpf() {
    return MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp('[0-9]')});
  }

  static MaskTextInputFormatter date() {
    return MaskTextInputFormatter(
        mask: '##/##/####', filter: {"#": RegExp('[0-9]')});
  }

  static MaskTextInputFormatter height() {
    return MaskTextInputFormatter(
        mask: '#.## m',
        filter: {"#": RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);
  }

  static MaskTextInputFormatter weight() {
    return MaskTextInputFormatter(
        mask: '### Kg',
        filter: {"#": RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);
  }

  static MaskTextInputFormatter weightSmall() {
    return MaskTextInputFormatter(
        mask: '## Kg',
        filter: {"#": RegExp('[0-9]')},
        type: MaskAutoCompletionType.eager);
  }

  static MaskTextInputFormatter decimal() {
    return MaskTextInputFormatter(
        mask: '##.##', filter: {"#": RegExp('[0-9]')});
  }

  static FilteringTextInputFormatter email() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z@_.\-+]'));
  }

  static MaskTextInputFormatter cref() {
    return MaskTextInputFormatter(
      type: MaskAutoCompletionType.eager,
        mask: '######-@/@@',
        filter: {'#': RegExp('[0-9]'), '@': RegExp('[A-Z]')});
  }

  static String effortFormatter(int effort) {
    switch (effort) {
      case 1:
        return '😣';
      case 2:
        return '🙁';
      case 3:
        return '😐';
      case 4:
        return '🙂';
      case 5:
        return '😃';
      default:
        return 'X';
    }
  }
}
