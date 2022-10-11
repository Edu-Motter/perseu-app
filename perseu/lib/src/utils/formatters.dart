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

  static MaskTextInputFormatter decimal() {
    return MaskTextInputFormatter(
        mask: '##.##', filter: {"#": RegExp('[0-9]')});
  }

  static MaskTextInputFormatter cvv() {
    return MaskTextInputFormatter(mask: '####', filter: {"#": RegExp('[0-9]')});
  }

  static FilteringTextInputFormatter email() {
    return FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z@_.\-+]'));
  }

  static MaskTextInputFormatter phone() {
    return MaskTextInputFormatter(
        mask: '(##) #####-####', filter: {"#": RegExp('[0-9]')});
  }
}
