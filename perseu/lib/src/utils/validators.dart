import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:form_field_validator/form_field_validator.dart';

export 'package:form_field_validator/form_field_validator.dart';

class CpfValidator extends TextFieldValidator {
  CpfValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    return CPFValidator.isValid(value);
  }
}

class SecurityCodeValidator extends PatternValidator {
  static const String _pattern = '^[0-9]{4}\$';
  SecurityCodeValidator({String errorText = 'O código de segurança precisa ter 4 números'}): super(_pattern, errorText: errorText);
}

class CreditCardNumberValidator extends PatternValidator {
  static const String _pattern = '^[0-9]{16}\$';
  CreditCardNumberValidator({String errorText = 'O número de cartão informado é inválido'}): super(_pattern, errorText: errorText);

  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    return super.isValid(value.replaceAll(RegExp('[^0-9]'), ''));
  }
}

class AmexNumberValidator extends PatternValidator {
  AmexNumberValidator(
      {String errorText = 'O número de cartão informado é inválido'})
      : super('^[0-9]{15,16}\$', errorText: errorText);

  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }
    return super.isValid(value.replaceAll(RegExp('[^0-9]'), ''));
  }
}

class CvvValidator extends PatternValidator {
  static const String _pattern = '^[0-9]{3,4}\$';
  CvvValidator({String errorText = 'O CVV precisa ter 3 ou 4 números'}): super(_pattern, errorText: errorText);
}

class ExpiryDateValidator extends PatternValidator {
  static const String _pattern = '^(?:(?:0[1-9])|(?:1[0-2]))/[0-9]{2}\$';
  ExpiryDateValidator({String errorText = 'A data de expiração é inválida'}): super(_pattern, errorText: errorText);
}

class SimpleEmailValidator extends PatternValidator {
  static const String _pattern = '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+\$';
  SimpleEmailValidator({String errorText = 'O email é inválido'}): super(_pattern, errorText: errorText);
}

class PhoneNumberValidator extends PatternValidator {
  static const _pattern = r'(\(?\d{2}\)?\s)?(\d{4,5}\-\d{4})';
  PhoneNumberValidator({String errorText = 'O telefone é inválido.'}): super(_pattern, errorText: errorText);
}
