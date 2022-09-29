import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Formatters {
  // ignore: unused_element
  Formatters._();

  static String cpfFormatter(String cpf) {
    return CPFValidator.format(cpf);
  }

  static MaskTextInputFormatter cpf() {
    return MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp('[0-9]')});
  }

  static String dateFormatter(String date) {
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}';
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
